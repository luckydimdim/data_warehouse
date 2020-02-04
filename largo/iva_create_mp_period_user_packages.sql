create
    definer = iva@`%` procedure iva_create_mp_period_user_packages(in current_period_id int)
begin

  if current_period_id is null then
    set current_period_id = iva_get_period_id(null);
  end if;

  insert largo.iva_user_packages
    (user_id, order_id, old_package_id, old_package_name, old_package_expires, new_package_id, new_package_name, new_package_expires, created, period_id)
  select
    orders.user_id,
    orders.order_id,
    orders.user_package_id,
    iva_get_package_name(orders.user_package_id),
    users.package_expires,
    orders.order_package_id,
    iva_get_package_name(orders.order_package_id),
    if (users.package_expires is null or users.package_expires < now(),
        date_add(now(), interval orders.order_subscription_in_month month),
        date_add(users.package_expires, interval orders.order_subscription_in_month month) ),
    orders.created,
    orders.period_id
  from
    iva_mp_orders orders

    join iva_users users
    on users.id = orders.user_id
  where
    orders.period_id = current_period_id
    and (orders.order_package_id is not null
      or orders.order_subscription_in_month is not null)

  on duplicate key update
    largo.iva_user_packages.user_id = users.id,
    largo.iva_user_packages.old_package_id = orders.user_package_id,
    largo.iva_user_packages.old_package_name = iva_get_package_name(orders.user_package_id),
    largo.iva_user_packages.old_package_expires = users.package_expires,
    largo.iva_user_packages.new_package_id = orders.order_package_id,
    largo.iva_user_packages.new_package_name = iva_get_package_name(orders.order_package_id),
    largo.iva_user_packages.new_package_expires =
      if (users.package_expires is null or users.package_expires < now(),
        date_add(now(), interval orders.order_subscription_in_month month),
        date_add(users.package_expires, interval orders.order_subscription_in_month month) ),
    largo.iva_user_packages.created = orders.created,
    largo.iva_user_packages.period_id = orders.period_id;

end;

