create
    definer = iva@`%` procedure iva_update_cmb_period_accruals(in current_period_id int)
begin

  if current_period_id is null then
    set current_period_id = iva_get_period_id(null);
  end if;

  select
    concat('call iva_update_summary_cmb_bonus_history(', order_id, ', ', period_id, ');')
  from
    libra.iva_cmb_orders
  where
    period_id = current_period_id
    and status = 'completed'
    and price > 0;
end;

