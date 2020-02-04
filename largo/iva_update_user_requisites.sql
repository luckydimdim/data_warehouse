create
    definer = iva@`%` procedure iva_update_user_requisites(in current_user_id int)
begin
    call iva_create_user_requisites(current_user_id);
end;

