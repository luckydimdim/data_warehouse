create
    definer = iva@`%` procedure iva_delete_cmb_user_orders(in current_user_id int)
begin

  delete from
    iva_cmb_orders
  where
    user_id = current_user_id;

  delete
    accruals
  from
    iva_cmb_extra_accruals accruals

    join iva_cmb_orders orders
    on orders.order_id = accruals.order_id
  where
    orders.user_id = current_user_id;


  call largo.iva_delete_cmb_user_orders(current_user_id);
end;

