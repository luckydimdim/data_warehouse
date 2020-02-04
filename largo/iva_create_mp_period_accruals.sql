create
    definer = iva@`%` procedure iva_create_mp_period_accruals(in current_period_id int)
begin

  if current_period_id is null then
    set current_period_id = iva_get_period_id(null);
  end if;

  insert iva_mp_accruals (
    order_id, created, period_id, order_positions, order_price, user_name_and_surname, partner_id,
    user_id, user_email, user_phone, user_package_name, user_generation, user_activation, kp, go, o1l,
    bo, ko, lb, bs, sb, gb, points, money, comment)
  select
    bonus.order_id,
    bonus.created,
    bonus.period_id,
    '',
    orders.price product_price,
    concat_ws(' ', users.name, users.surname) user_name_and_surname,
    bonus.target_user_id partner_id,
    users.id user_id,
    users.login user_email,
    ifnull(users.phone, '') user_phone,
    ifnull( package_history.old_package_name, iva_get_user_package_name(users.id, bonus.created) ),
    ifnull(child_tree.depth - parent_tree.depth, 0) + 1 user_generation,
    ifnull(activation_history.activation, false) activation,
    history.kp qualification,
    history.go - ifnull(prev_history.go, 0),
    history.o1l - ifnull(prev_history.o1l, 0),
    history.bo - ifnull(prev_history.bo, 0),
    history.ko - ifnull(prev_history.ko, 0),
    history.lb - ifnull(prev_history.lb, 0),
    history.bs - ifnull(prev_history.bs, 0),
    history.sb - ifnull(prev_history.sb, 0),
    history.gb - ifnull(prev_history.gb, 0),
    history.points - ifnull(prev_history.points, 0),
    (history.money - ifnull(prev_history.money, 0)),
    bonus.comment
  from
    libra.iva_mp_transactions bonus

    join libra.iva_mp_orders orders
    on orders.period_id = bonus.period_id
      and orders.order_id = bonus.order_id

    join libra.iva_mp_order_positions positions
    on positions.order_id = orders.order_id

    left join largo.iva_user_packages package_history
    on package_history.order_id = orders.id

    join libra.iva_mp_order_accruals history
    on history.order_id = bonus.order_id
      and history.user_id = bonus.target_user_id

    left join libra.iva_mp_order_accruals activation_history
    on activation_history.order_id = bonus.order_id
      and activation_history.user_id = bonus.source_user_id

    left join libra.iva_mp_transactions prev_order
    on prev_order.period_id = bonus.period_id
      and prev_order.target_user_id = bonus.target_user_id
      and prev_order.sequence = bonus.sequence - 1

    left join libra.iva_mp_order_accruals prev_history
    on prev_history.period_id = bonus.period_id
      and prev_history.order_id = prev_order.order_id
      and prev_history.user_id = bonus.target_user_id

    join largo.iva_users users
    on users.id = bonus.source_user_id

    left join libra.iva_mp_user_roots parent_tree
    on parent_tree.order_id = bonus.order_id
      and parent_tree.child_id = bonus.source_user_id
      and parent_tree.parent_id = bonus.target_user_id

    join libra.iva_mp_user_roots child_tree
    on child_tree.order_id = bonus.order_id
      and child_tree.child_id = bonus.source_user_id
      and child_tree.is_leaf = true
  where
    bonus.period_id = current_period_id
  group by
    bonus.target_user_id,
    bonus.order_id;

  update
    iva_mp_accruals accruals

    join libra.iva_mp_orders source_orders
    on source_orders.period_id = current_period_id
      and source_orders.order_id = accruals.order_id

    join libra.iva_mp_order_positions positions
    on positions.order_id = source_orders.order_id
  set
    accruals.order_positions = (
      select
        left(concat(group_concat(positions.name order by positions.name separator ', '), if (positions.quantity > 1, concat(' x ', positions.quantity, ' шт.'), '')), 255)
      from
        libra.iva_mp_orders orders

        join libra.iva_mp_order_positions positions
        on positions.order_id = orders.order_id
      where
        orders.period_id = current_period_id
        and orders.order_id = source_orders.order_id);
end;

