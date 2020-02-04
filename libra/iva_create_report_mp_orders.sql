create
    definer = iva@`%` procedure iva_create_report_mp_orders(in start  datetime,
                                                            in finish datetime,
                                                            in money  decimal(12, 4))
begin

  if money = 0 or money is null then
    select
      users.id,
      users.email,
      users.name_and_surname,
      users.package_name,
      orders.id,
      orders.total_id,
      iva_format_date(orders.created, false) created,
      group_concat(concat(positions.name, ' x ', positions.quantity, ' (', positions.amount, ' р.)') separator ' | ') positions,
      orders.price,
    concat( iva_get_package_name(packages.for_package_id), ' -> ', iva_get_package_name(packages.package_id) ) upgrade
    from
      iva_mp_orders orders

      join iva_mp_order_positions positions
      on positions.order_id = orders.order_id

      left join largo.iva_mp_position_packages packages
      on packages.total_position_id = positions.total_id

      join largo.iva_users users
      on users.id = orders.user_id
    where
      orders.created between start and finish
      and orders.status = 'completed'
    group by
      orders.order_id
    order by
      users.email asc;
  else
    select
      user_id,
      email,
      name_and_surname,
      package_name,
      group_concat(order_id separator ', ') order_id,
      group_concat(total_id separator ', ') total_id,
      group_concat(created separator ', ') created,
      group_concat(positions separator ', ') positions,
      sum(order_price) order_price,
      group_concat(upgrade separator ', ') upgrade
    from
      (select
        users.id user_id,
        users.email,
        users.name_and_surname,
        users.package_name,
        orders.id order_id,
        orders.total_id,
        iva_format_date(orders.created, false) created,
        group_concat(concat(positions.name, ' x ', positions.quantity, ' (', positions.amount, ' р.)') separator ' | ') positions,
        orders.price order_price,
        concat( iva_get_package_name(packages.for_package_id), ' -> ', iva_get_package_name(packages.package_id) ) upgrade
      from
        iva_mp_orders orders

        join iva_mp_order_positions positions
        on positions.order_id = orders.order_id

        left join largo.iva_mp_position_packages packages
        on packages.total_position_id = positions.total_id

        join largo.iva_users users
        on users.id = orders.user_id
      where
        orders.created between start and finish
        and orders.status = 'completed'
      group by
        orders.order_id) tbl
      group by
        user_id
      having
        sum(order_price) >= money
      order by
        email asc;
  end if;

end;

