create
    definer = iva@`%` procedure iva_delete_mp_user_orders(in current_user_id int)
begin

  delete
    positions,
    orders
  from
    iva_mp_order_positions positions

    join iva_mp_orders orders
    on orders.id = positions.order_id
      and orders.user_id = current_user_id;


  call largo.iva_delete_mp_user_orders(current_user_id);

end;

