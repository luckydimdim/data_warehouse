create
    definer = iva@`%` procedure iva_delete_user_operations(in current_user_id int)
begin

  call iva_delete_mp_user_transactions(current_user_id);
  call iva_delete_cmb_user_transactions(current_user_id);
  call iva_delete_user_accruals(current_user_id);

end;

