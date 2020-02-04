create
    definer = iva@`%` procedure iva_update_mp_user_roots(in current_user_id int)
begin

  update
    iva_mp_customer_roots roots

    join iva_users users
    on users.id = roots.parent_id
  set
    roots.parent_email = users.email,
    roots.parent_name_and_surname = concat_ws(' ', users.name, users.surname),
    roots.parent_package_name = users.package_name
  where
    roots.parent_id = current_user_id;

  update
    iva_mp_customer_roots roots

    join iva_users users
    on users.id = roots.child_id
  set
    roots.child_email = users.email,
    roots.child_name_and_surname = concat_ws(' ', users.name, users.surname),
    roots.child_package_name = users.package_name
  where
    roots.child_id = current_user_id;

end;

