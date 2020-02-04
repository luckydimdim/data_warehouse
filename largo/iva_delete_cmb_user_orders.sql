create
    definer = iva@`%` procedure iva_delete_cmb_user_orders(in current_user_id int)
begin
  delete from
    iva_cmb_orders
  where
    user_id = current_user_id;
end;

