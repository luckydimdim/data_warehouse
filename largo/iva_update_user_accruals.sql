create
    definer = iva@`%` procedure iva_update_user_accruals(in current_user_id int)
begin

  update
    iva_cmb_accruals accruals

    join iva_users users
    on users.id = accruals.user_id
  set
    accruals.user_name_and_surname = concat_ws(' ', users.name, users.surname),
    accruals.user_email = users.login,
    accruals.user_phone = ifnull(users.phone, ''),
    accruals.user_package_name = users.package_name
  where
    accruals.user_id = current_user_id;

  update
    iva_mp_accruals accruals

    join iva_users users
    on users.id = accruals.user_id
  set
    accruals.user_name_and_surname = concat_ws(' ', users.name, users.surname),
    accruals.user_email = users.login,
    accruals.user_phone = ifnull(users.phone, ''),
    accruals.user_package_name = users.package_name
  where
    accruals.user_id = current_user_id;

end;

