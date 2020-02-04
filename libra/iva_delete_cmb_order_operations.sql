create
    definer = iva@`%` procedure iva_delete_cmb_order_operations(in current_order_id  int,
                                                                in current_period_id int)
begin

  if current_period_id is null then
    set current_period_id = iva_get_period_id(null);
  end if;

  call iva_delete_cmb_order_transactions(current_order_id, current_period_id);
  call iva_update_cmb_period_accruals(current_period_id);
  call iva_create_cmb_order_extra_accruals_cancel(current_order_id, current_period_id);


  call largo.iva_delete_cmb_order_accruals(current_order_id, current_period_id);


  call largo.iva_update_cmb_period_profits(current_period_id);
  call largo.iva_update_user_totals(current_period_id);
  call largo.iva_update_cmb_user_branches(current_period_id);

end;

