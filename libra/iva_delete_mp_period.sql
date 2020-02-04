create
    definer = iva@`%` procedure iva_delete_mp_period(in current_period_id int)
begin

  if current_period_id is null then
    set current_period_id = iva_get_period_id(null);
  end if;

  call iva_delete_mp_period_transactions(current_period_id);
  call iva_delete_mp_period_accruals(current_period_id);
  call iva_delete_mp_period_order_accruals(current_period_id);
  call iva_delete_mp_period_user_roots(current_period_id);
  call iva_delete_mp_period_user_branches(current_period_id);
  call iva_delete_mp_period_user_packages(current_period_id);
  call iva_delete_mp_period_orders(current_period_id);

end;

