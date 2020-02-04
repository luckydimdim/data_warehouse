create
    definer = iva@`%` procedure iva_read_mp_user_branches(in current_user_id int)
begin
  call largo.iva_read_mp_user_branches(current_user_id);
end;

