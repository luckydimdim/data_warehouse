create
    definer = iva@`%` procedure iva_update_user_root(in current_user_id int)
begin

  call largo.iva_create_user_root(current_user_id);

end;

