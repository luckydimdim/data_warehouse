create
    definer = iva@`%` procedure iva_create_user(in current_user_id int)
begin


  call largo.iva_create_user(current_user_id);
  call largo.iva_create_user_root(current_user_id);
  call largo.iva_create_user_branch(current_user_id);
end;

