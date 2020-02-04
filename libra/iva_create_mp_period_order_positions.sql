create
    definer = iva@`%` procedure iva_create_mp_period_order_positions(in current_period_id int)
begin

  if current_period_id is null then
    set current_period_id = iva_get_period_id(null);
  end if;

  insert iva_mp_order_positions
    (order_id, total_id, name, quantity, price, amount, currency)
  select
    positions.property_2208,
    positions.property_2209,
    positions.property_2210,
    positions.property_2211,
    positions.property_2212,
    positions.property_2213,
    positions.property_2214
  from
    iva.b_iblock_element_prop_s89 positions
  where
    positions.property_2223 = current_period_id;
end;

