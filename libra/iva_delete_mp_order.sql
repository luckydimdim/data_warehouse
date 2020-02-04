create
    definer = iva@`%` procedure iva_delete_mp_order(in current_order_id int)
begin

  delete
    orders,
    positions
  from
    iva_mp_orders orders

    join iva_mp_order_positions positions
    on positions.order_id = orders.order_id
  where
    orders.order_id = current_order_id;


  call largo.iva_delete_mp_order(current_order_id);
end;

