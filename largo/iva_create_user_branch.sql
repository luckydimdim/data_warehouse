create
    definer = iva@`%` procedure iva_create_user_branch(in current_user_id int)
begin

  call iva_update_user_branch(current_user_id, null);

end;

