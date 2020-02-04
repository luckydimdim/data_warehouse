create
    definer = iva@`%` procedure iva_update_cmb_order(in current_order_id int)
begin
    call iva_create_cmb_order(current_order_id);
end;

