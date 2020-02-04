create
    definer = iva@`%` procedure iva_read_cmb_period_orders(in current_period_id int)
begin
  if current_period_id is null then
    set current_period_id = iva_get_period_id(null);
  end if;

  select
    order_props.order_id,
    order_props.created,
    concat('call iva_create_cmb_accruals(', order_props.order_id, ', ', current_period_id, ');') create_accruals,
    'update iva_cmb_extra_accruals set status = ''new'' where period_id = current_period_id;' update_extra_accruals
  from
    iva_cmb_orders order_props
  where
    order_props.period_id = current_period_id
    and order_props.status in ('new', 'completed')
  order by
    order_props.created asc;

end;

