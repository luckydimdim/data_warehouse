create
    definer = iva@`%` procedure iva_delete_cmb_order(in current_order_id int)
begin
  delete from
    iva_cmb_orders
  where
    order_id = current_order_id;
end;

