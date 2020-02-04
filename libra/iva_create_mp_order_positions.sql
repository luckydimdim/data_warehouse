create
    definer = iva@`%` procedure iva_create_mp_order_positions(in current_order_id int)
begin
  insert iva_mp_order_positions
    (order_id, total_id, name, quantity, price, amount, currency, period_id)
  select
    positions.property_2208,
    positions.property_2209,
    positions.property_2210,
    positions.property_2211,
    positions.property_2212,
    positions.property_2213,
    positions.property_2214,
    positions.property_2223
  from
    iva.b_iblock_element_prop_s89 positions
  where
    positions.property_2208 = current_order_id;
end;

