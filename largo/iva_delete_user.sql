create
    definer = iva@`%` procedure iva_delete_user(in current_user_id int)
begin
  delete from
    iva_users
  where
    id = current_user_id;

  delete from
    iva_user_groups
  where
    user_id = current_user_id;

  delete from
    iva_user_requisites
  where
    id = current_user_id;

  delete from
    iva_user_packages
  where
    user_id = current_user_id;
end;

