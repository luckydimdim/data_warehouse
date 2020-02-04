create
    definer = iva@`%` procedure iva_read_cmb_period_missing_summary_accruals(in current_period_id int)
begin
  if current_period_id is null then
    set current_period_id = iva_get_period_id(null);
  end if;

  select distinct
    payment_props.order_id,
    concat('call iva_add_summary_cmb_accruals(', payment_props.order_id, ', ', payment_props.period_id, ');')
  from
    iva_cmb_orders payment_props

    left join largo.iva_cmb_accruals accruals
    on accruals.period_id = current_period_id
      and accruals.order_id = payment_props.order_id
  where
    payment_props.period_id = current_period_id
    and accruals.id is null;
end;

