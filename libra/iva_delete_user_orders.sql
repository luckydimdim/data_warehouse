create
    definer = iva@`%` procedure iva_delete_user_orders(in current_user_id int)
begin
  call iva_delete_mp_user_orders(current_user_id);
  call iva_delete_cmb_user_orders(current_user_id);
end;

