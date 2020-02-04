create
    definer = iva@`%` procedure iva_create_cmb_order_transactions(in current_order_id  int,
                                                                  in current_period_id int)
begin

  calculations: begin

    declare current_user_id int;
    declare current_user_package_id int;
    declare current_user_package_name varchar(255);
    declare current_user_cmb_percent decimal(9, 2);
    declare payment_date datetime;
    declare payment_price decimal(9, 2);
    declare order_exists bool default false;
    declare position_name varchar(255);

    if current_period_id is null then
      set current_period_id = iva_get_period_id(null);
    end if;

    set @bonuses_exists = if ((
      select
        max(id)
      from
        iva_cmb_transactions
      where
        period_id = current_period_id
        and order_id = current_order_id) is null, false, true);

    if @bonuses_exists = true then
      leave calculations;
    end if;

    if current_period_id is null then
      set current_period_id = iva_get_period_id(null);
    end if;

    select
      if (payment_props.order_id is null, false, true),
      payment_props.user_id,
      payment_props.created,
      if (user_props.has_business = true, iva_get_package_id('Business'), iva_get_user_package_id(user_props.id, payment_props.created)),
      if (user_props.has_business = true, 'Business', iva_get_user_package_name(user_props.id, payment_props.created)),
      payment_props.price,
      payment_props.name
    into
      order_exists,
      current_user_id,
      payment_date,
      current_user_package_id,
      current_user_package_name,
      payment_price,
      position_name
    from
      iva_cmb_orders payment_props

      join largo.iva_users user_props
      on user_props.id = payment_props.user_id
    where
       payment_props.order_id = current_order_id;

    set current_user_cmb_percent = iva_get_cmb_comission(current_user_package_id) / 100;

    if order_exists = false then
      leave calculations;
    end if;

    create temporary table iva_temp_bonus_tree
    (
      id int not null auto_increment,
      order_id int not null,
      child_id int not null,
      parent_id int not null,
      depth int not null,
      is_leaf bool not null,
      datetime datetime default current_timestamp() not null,
      parent_package_id int default 0 not null,
      parent_subscriptions_expired bool default true not null,
      constraint iva_temp_bonus_tree_id_uindex unique (id)
    ) charset = utf8;

    insert iva_temp_bonus_tree
      (order_id, child_id, parent_id, depth, datetime, is_leaf, parent_package_id, parent_subscriptions_expired)
    select
      current_order_id, child_id, users_tree.parent_id, depth, payment_date, false, iva_get_user_package_id(user_props.id, payment_date), ifnull(user_props.package_expires < payment_date, true)
    from
      largo.iva_user_roots users_tree

      join largo.iva_users user_props
      on user_props.id = users_tree.parent_id
    where
      users_tree.child_id = current_user_id;

    create index iva_temp_bonus_tree_child_id_parent_id_index
      on iva_temp_bonus_tree (parent_id, child_id, order_id);

    create index iva_temp_bonus_tree_child_id_order_id_index
      on iva_temp_bonus_tree (child_id, order_id);

    create index iva_temp_bonus_tree_order_id_child_id_depth_index
      on iva_temp_bonus_tree (order_id, child_id, depth);

    delete quick from
      iva_temp_bonus_tree
    where
      parent_package_id = iva_get_package_id('s')
      or parent_subscriptions_expired = true;

    set @depth = -1;
    update
      iva_temp_bonus_tree
    set
      depth = @depth := @depth + 1
    where
      child_id = current_user_id
      and order_id = current_order_id;

    update
      iva_temp_bonus_tree
    set
      is_leaf = true
    where
      order_id = current_order_id
      and (child_id, depth) in (
        select
          child_id,
          max(depth) max_depth
        from
          iva_temp_bonus_tree
        where
          child_id = current_user_id
          and order_id = current_order_id
        group by
          child_id);

    set @is_exception = (
      if (
        (select
          id
        from
          iva_cmb_excepted_positions
        where
          position_name like concat(name, '%') limit 1) is null, false, true ));

    if @is_exception = true then
      insert iva_cmb_transactions
        (order_id, created, source_user_id, source_package_name, target_user_id,
         target_package_name, price, points, period_id, comment, is_leaf, status)
      select
        current_order_id,
        payment_date,
        current_user_id,
        current_user_package_name,
        user_props.id,
        if (user_props.has_business = true, 'Business', iva_get_user_package_name(user_props.id, payment_date)),
        0 price,
        0 points,
        current_period_id,
        'Заказ без начислений',
        parents.is_leaf,
        'completed'
      from
        iva_temp_bonus_tree children

        join iva_temp_bonus_tree parents
        on parents.child_id = children.child_id
          and children.depth - parents.depth <= 4

        join largo.iva_users user_props
        on user_props.id = parents.parent_id
      where
        children.child_id = current_user_id
        and children.is_leaf = true;
    else
      insert iva_cmb_transactions
        (order_id, created, source_user_id, source_package_name, target_user_id,
         target_package_name, price, points, period_id, is_leaf, status)
      select
        current_order_id,
        payment_date,
        current_user_id,
        current_user_package_name,
        user_props.id,
        if (user_props.has_business = true, 'Business', iva_get_user_package_name(user_props.id, payment_date)),

        iva_get_package_ratio( iva_get_user_package_id(user_props.id, payment_date) )
          * payment_price
          * current_user_cmb_percent
          * iva_get_cmb_generation_percent(children.depth - parents.depth) / 100,

        iva_get_package_ratio( iva_get_user_package_id(user_props.id, payment_date) )
          * payment_price
          * current_user_cmb_percent
          * iva_get_cmb_generation_percent(children.depth - parents.depth) / 100
          / 60,
        current_period_id,
        parents.is_leaf,
        'completed'
      from
        iva_temp_bonus_tree children

        join iva_temp_bonus_tree parents
        on parents.child_id = children.child_id
          and children.depth - parents.depth <= 4

        join largo.iva_users user_props
        on user_props.id = parents.parent_id
      where
        children.child_id = current_user_id
        and children.is_leaf = true;
    end if;

    drop temporary table iva_temp_bonus_tree;

  end;
end;

