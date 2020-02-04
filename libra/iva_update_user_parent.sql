create
    definer = iva@`%` procedure iva_update_user_parent(in current_user_id int,
                                                       in new_parent_id   int)
proc:begin

  if current_user_id is null
       or new_parent_id is null
       or current_user_id = new_parent_id then
    leave proc;
  end if;

  call largo.iva_create_user(current_user_id);

  update
    largo.iva_mp_customer_roots tree

    join largo.iva_users users
    on users.id = tree.parent_id
  set
    tree.parent_name_and_surname = concat_ws(' ', ifnull(users.name, ''), ifnull(users.surname, '')),
    tree.parent_package_name = users.package_name,
    tree.parent_email = users.login
  where
    tree.parent_id = current_user_id;

  call largo.iva_update_user_root(current_user_id);
  call largo.iva_delete_user_branch(current_user_id);
  call largo.iva_create_user_branch(current_user_id);

  call largo.iva_create_user_branches(current_user_id, null);
end;

