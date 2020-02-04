create
    definer = iva@`%` procedure iva_read_mp_period_orders(in current_period_id int)
begin

  if current_period_id is null then
    set current_period_id = iva_get_period_id(null);
  end if;

  select
    order_props.order_id,
    order_props.created,
    concat_ws(' ',
      concat('call iva_delete_mp_order_operations(', order_props.order_id, ', ', current_period_id, ');'),
      concat('call iva_delete_mp_order(', order_props.order_id, ');')
  ) delete_order,
    concat_ws(' ',
      concat('call iva_create_mp_order(', order_props.order_id, ');'),
      concat('call iva_create_mp_accruals(', order_props.order_id, ', ', current_period_id, ');')
  ) crete_order,
    concat('call iva_create_mp_accruals(', order_props.order_id, ', ', current_period_id, ');') crete_accrual
  from
    iva_mp_orders order_props
  where
    order_props.period_id = current_period_id
    and order_props.status in ('new', 'completed')
  order by
    order_props.created asc;

end;

