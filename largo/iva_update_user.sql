create
    definer = iva@`%` procedure iva_update_user(in current_user_id int)
begin
  call iva_create_user(current_user_id);

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
    iva_user_branches pc

    join iva_users users
    on users.id = pc.child_id
  set
    pc.name = ifnull(users.name, ''),
    pc.surname = ifnull(users.surname, ''),
    pc.name_and_surname = concat_ws(' ', ifnull(users.name, ''), ifnull(users.surname, '')),
    pc.email = users.login,
    pc.phone = ifnull(users.phone, ''),
    pc.package_id = users.package_id,
    pc.package_name = users.package_name,
    pc.subscription_expire = users.package_expires,
    pc.is_password_expired = users.is_password_expired
  where
    pc.is_trash = false
    and pc.child_id = current_user_id;

  update
    iva_mp_customer_roots tree

    join iva_users users
    on users.id = tree.child_id
  set
    tree.child_name_and_surname = concat_ws(' ', users.name, users.surname),
    tree.child_package_name = users.package_name,
    tree.child_email = users.login
  where
    tree.child_id = current_user_id;

  update
    iva_mp_customer_roots tree

    join iva_users users
    on users.id = tree.parent_id
  set
    tree.parent_name_and_surname = concat_ws(' ', ifnull(users.name, ''), ifnull(users.surname, '')),
    tree.parent_package_name = users.package_name,
    tree.parent_email = users.login
  where
    tree.parent_id = current_user_id;
end;

