create
    definer = iva@`%` procedure iva_delete_cmb_period_operations(in current_period_id int)
begin

  if current_period_id is null then
    set current_period_id = iva_get_period_id(null);
  end if;

  call iva_delete_cmb_period_transactions(current_period_id);
  call iva_delete_cmb_period_accruals(current_period_id);
  call iva_create_cmb_period_extra_accruals_cancel(current_period_id);


  call largo.iva_delete_cmb_period_accruals(current_period_id);
  call largo.iva_create_cmb_period_profits_cancel(current_period_id);
  call largo.iva_update_user_totals(current_period_id);
  call largo.iva_create_cmb_branches_cancel();

end;

