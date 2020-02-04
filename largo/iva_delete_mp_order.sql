create
    definer = iva@`%` procedure iva_delete_mp_order(in current_order_id int)
begin
  delete from
    iva_mp_orders
  where
    order_id = current_order_id;
end;

