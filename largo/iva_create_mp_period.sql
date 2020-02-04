create
    definer = iva@`%` procedure iva_create_mp_period(in current_period_id int)
begin

  if current_period_id is null then
    set current_period_id = iva_get_period_id(null);
  end if;

  call largo.iva_create_mp_period_orders(current_period_id);
  call largo.iva_create_mp_period_user_packages(current_period_id);
  call largo.iva_update_mp_period_users(current_period_id);
  call largo.iva_update_mp_period_user_activations(current_period_id);
  call largo.iva_create_mp_period_accruals(current_period_id);
  call largo.iva_update_mp_period_profits(current_period_id);
  call largo.iva_create_mp_period_user_root(current_period_id);
  call largo.iva_update_user_totals(current_period_id);
  call largo.iva_update_mp_period_branches(current_period_id);

end;

