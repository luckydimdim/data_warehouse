create
    definer = iva@`%` procedure iva_update_mp_order(in current_order_id int)
begin
  call iva_create_mp_order(current_order_id);
end;

