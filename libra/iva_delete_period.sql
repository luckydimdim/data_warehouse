create
    definer = iva@`%` procedure iva_delete_period(in current_period_id int)
begin

  if current_period_id is null then
    set current_period_id = iva_get_period_id(null);
  end if;

  call iva_delete_cmb_period_operations(current_period_id);
  call iva_delete_cmb_period_orders(current_period_id);

  call iva_delete_mp_period_operations(current_period_id);
  call iva_delete_mp_period_orders(current_period_id);

  call largo.iva_delete_period_profits(current_period_id);
end;

