create
    definer = iva@`%` procedure iva_create_mp_order_user_package(in param_order_id int)
begin

  declare param_user_id int default null;
  declare param_old_package_id int default null;
  declare param_old_package_expires datetime default null;
  declare param_new_package_id int default null;
  declare param_new_package_expires datetime default null;
  declare order_subscription_in_month int default 0;
  declare order_created        datetime default null;

  select
    orders.user_id,
    orders.user_package_id,
    users.package_expires,
    orders.order_package_id,
    orders.order_subscription_in_month,
    orders.created
  into
    param_user_id,
    param_old_package_id,
    param_old_package_expires,
    param_new_package_id,
    order_subscription_in_month,
    order_created
  from
    iva_mp_orders orders

    join iva_users users
    on users.id = orders.user_id
  where
    orders.order_id = param_order_id;

  if param_old_package_id <> param_new_package_id
    or param_old_package_expires <> param_new_package_expires then

    if param_old_package_expires is null or param_old_package_expires < now() then
      set param_new_package_expires = date_add(now(), interval order_subscription_in_month month);
    else
      set param_new_package_expires = date_add(param_old_package_expires, interval order_subscription_in_month month);
    end if;

    call largo.iva_update_user_package(param_user_id,
                                       param_order_id,
                                       param_old_package_id,
                                       param_old_package_expires,
                                       param_new_package_id,
                                       param_new_package_expires,
                                       order_created);

  end if;
end;

