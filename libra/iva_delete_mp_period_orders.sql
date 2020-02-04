create
    definer = iva@`%` procedure iva_delete_mp_period_orders(in current_period_id int)
begin

  if current_period_id is null then
    set current_period_id = iva_get_period_id(null);
  end if;

  delete
    positions
  from
    iva_mp_orders orders

    join iva_mp_order_positions positions
    on positions.order_id = orders.order_id
  where
    orders.period_id = current_period_id;

  delete from
    iva_mp_orders
  where
    period_id = current_period_id;
end;

