create
    definer = iva@`%` procedure iva_delete_user_accruals(in current_user_id int)
begin
  call iva_delete_mp_user_accruals(current_user_id);
  call iva_delete_mp_order_user_accruals(current_user_id);
  call iva_delete_cmb_user_accruals(current_user_id);


  call largo.iva_delete_mp_user_accruals(current_user_id);
  call largo.iva_delete_cmb_user_accruals(current_user_id);
end;

