create
    definer = iva@`%` procedure iva_create_report_cmb_period_missing_accruals(in current_period_id int)
begin

  if current_period_id is null then
    set current_period_id = iva_get_period_id(null);
  end if;

  select distinct
    orders.order_id,
    concat('call iva_create_cmb_accruals(', orders.order_id, ', ', current_period_id, ');') create_accruals
  from
    iva_cmb_orders orders

    left join largo.iva_cmb_accruals accruals
    on accruals.period_id = current_period_id
      and accruals.order_id = orders.order_id
  where
    orders.period_id = current_period_id
    and accruals.id is null;
end;

