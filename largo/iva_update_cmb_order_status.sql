create
    definer = iva@`%` procedure iva_update_cmb_order_status(in current_order_id int)
begin
    update
      iva_cmb_orders target

      join libra.iva_cmb_orders source
      on source.order_id = target.order_id
    set
      target.status = source.status,
      target.partial_payment_status = source.partial_payment_status
    where
      target.order_id = current_order_id;
end;

