create
    definer = iva@`%` procedure iva_read_period_connection_report(in current_period_id   int,
                                                                  in current_finish_date datetime)
begin
  if current_period_id is null then
    set current_period_id = iva_get_period_id(null);
  end if;

  if current_finish_date is null then
    set current_finish_date = iva_get_period_finish(current_period_id);
  end if;

  with own_orders (user_id, period_id, positions, upgrade, amount, datetime) as (
    select
      own_orders.user_id,
      own_orders.period_id,
      group_concat(concat(own_positions.name, ' x ', own_positions.quantity, ' (', own_positions.amount, ' р.)') separator ' | ') own_positions,
      concat( iva_get_package_name(own_packages.for_package_id), ' -> ', iva_get_package_name(own_packages.package_id) ) own_upgrade,
      sum( if (own_positions.amount is null or own_packages.for_package_id is not null, 0, own_positions.amount) ) amount,
      if (own_packages.for_package_id is not null, own_orders.created, null) own_date
    from
      iva_mp_orders own_orders

      left join iva_mp_order_positions own_positions
      on own_positions.order_id = own_orders.order_id

      left join largo.iva_mp_position_packages own_packages
      on own_packages.total_position_id = own_positions.total_id
    where
      own_orders.period_id in (current_period_id)
      and own_orders.created <= current_finish_date
      and own_orders.status = 'completed'
    group by
      own_orders.user_id),

    connections (user_id, package_name, activation, gold, platinum, upgrade) as (
      select
        results.user_id,
        results.package_name,
        results.activation,
        sum( if (orders.order_package_id = iva_get_package_id('g'), 1, 0) ) gold,
        sum( if (orders.order_package_id = iva_get_package_id('p') and history.old_package_id = iva_get_package_id('s'), 1, 0) ) platinum,
        sum( if (orders.order_package_id = iva_get_package_id('p') and history.old_package_id = iva_get_package_id('g'), 1, 0) ) upgrade
      from
        iva_mp_accruals results

        left join largo.iva_mp_accruals accruals
        on accruals.period_id = results.period_id
          and accruals.partner_id = results.user_id
          and accruals.user_generation = 1

        left join largo.iva_mp_orders orders
        on orders.order_id = accruals.order_id

        left join largo.iva_user_packages history
        on history.order_id = orders.order_id

        left join own_orders
        on own_orders.user_id = accruals.partner_id
          and own_orders.period_id = accruals.period_id
      where
        results.period_id = current_period_id
        and accruals.created <= current_finish_date
        and (results.activation <> 0 or orders.order_package_id is not null)
      group by
        results.user_id)

  select
    users.id,
    concat_ws(' ', users.name, users.surname) name_and_surname,
    users.email,
    users.package_name,
    ifnull(connections.activation, false) activation,
    ifnull(users.package_name <> 'Silver' and ((own_orders.upgrade is not null and own_orders.amount >= 6000) or own_orders.amount >= 12000), false) hyper,
    ifnull(connections.gold, 0) gold,
    ifnull(connections.platinum, 0) platinum,
    ifnull(connections.upgrade, 0) upgrade,
    own_orders.positions,
    ifnull(own_orders.amount, 0) amount,
    own_orders.upgrade,
    if ( own_orders.datetime is null, '', iva_format_date(own_orders.datetime, false) ) upgrade_date
  from
    largo.iva_users users

    left join connections
    on connections.user_id = users.id

    left join own_orders
    on own_orders.user_id = users.id
      and own_orders.period_id = current_period_id
  where
    (connections.user_id is not null or own_orders.user_id is not null)
    and users.id not in (1, 2)
  order by
    hyper desc,
    users.surname asc;
end;

