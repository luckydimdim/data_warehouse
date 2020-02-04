create
    definer = iva@`%` procedure iva_update_mp_order_status(in current_order_id int)
begin
    update
      iva_mp_orders target

      join libra.iva_mp_orders source
      on source.order_id = target.order_id
    set
      target.status = source.status,
      target.accruals_status = source.accruals_status
    where
      target.order_id = current_order_id;
end;

