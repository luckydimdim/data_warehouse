create
    definer = iva@`%` procedure iva_update_user_package(in param_user_id             int,
                                                        in param_order_id            int,
                                                        in param_old_package_id      int,
                                                        in param_old_package_expires datetime,
                                                        in param_new_package_id      int,
                                                        in param_new_package_expires datetime,
                                                        in order_created             datetime)
begin
  insert largo.iva_user_packages
    (user_id, order_id, old_package_id, old_package_name, old_package_expires, new_package_id, new_package_name, new_package_expires, created, period_id)
  select
    param_user_id,
    param_order_id,
    param_old_package_id,
    iva_get_package_name(param_old_package_id),
    param_old_package_expires,
    param_new_package_id,
    iva_get_package_name(param_new_package_id),
    param_new_package_expires,
    order_created,
    iva_get_period_id(order_created)

  on duplicate key update
    user_id = param_user_id,
    old_package_id = param_old_package_id,
    old_package_name = iva_get_package_name(param_old_package_id),
    old_package_expires = param_old_package_expires,
    new_package_id = param_new_package_id,
    new_package_name = iva_get_package_name(param_new_package_id),
    new_package_expires = param_new_package_expires,
    created = order_created,
    period_id = iva_get_period_id(order_created);
end;

