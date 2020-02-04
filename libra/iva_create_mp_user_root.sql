create
    definer = iva@`%` procedure iva_create_mp_user_root(in current_order_id  int,
                                                        in current_period_id int)
begin

    declare current_user_id int;
    declare payment_date datetime;

    if current_period_id is null then
      set current_period_id = iva_get_period_id(null);
    end if;

    delete from
      iva_mp_user_roots
    where
      period_id = current_period_id
      and order_id = current_order_id;

    select
      order_props.user_id,
      order_props.created
    into
      current_user_id,
      payment_date
    from
      iva_mp_orders order_props
    where
      order_props.period_id = current_period_id
      and order_props.order_id = current_order_id;


    insert iva_mp_user_roots
      (order_id, period_id, child_id, parent_id, depth, created, is_leaf)
    select
      current_order_id, current_period_id, child_id, parent_id, depth, created, is_leaf
    from
      iva_mp_user_roots
    where
      period_id = current_period_id
      and order_id = (
        select
          previous.order_id
        from
          iva_mp_orders current

          join iva_mp_orders previous
          on previous.period_id = current.period_id
            and previous.sequence = current.sequence - 1
        where
          current.order_id = current_order_id)
      and child_id <> current_user_id;


    insert iva_mp_user_roots
      (order_id, period_id, child_id, parent_id, depth, created, is_leaf)
    select
      current_order_id, current_period_id, child_id, tree.parent_id, depth, payment_date, false
    from
      largo.iva_user_roots tree


      join iva_users user
      on user.user_id = tree.parent_id
        and user.package_name <> 'Silver'
        and user.package_expires >= payment_date
    where
      tree.child_id = current_user_id;


    set @depth = -1;
    update
      iva_mp_user_roots
    set
      depth = @depth := @depth + 1
    where
      order_id = current_order_id
      and child_id = current_user_id
    order by
      depth asc;


    update
      iva_mp_user_roots
    set
      is_leaf = true
    where
      order_id = current_order_id
      and (child_id, depth) in (
        select
          child_id,
          max(depth) max_depth
        from
          iva_mp_user_roots
        where
          order_id = current_order_id
          and child_id = current_user_id
        group by
          child_id);

end;

