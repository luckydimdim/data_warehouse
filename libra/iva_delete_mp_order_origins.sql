create
    definer = iva@`%` procedure iva_delete_mp_order_origins(in current_order_id int)
begin

  delete from
    iva.b_iblock_element_prop_s74
  where
    iblock_element_id = current_order_id;

  delete from
    iva.b_iblock_element
  where
    id = current_order_id;

  delete
    positions,
    position_props
  from
    iva.b_iblock_element_prop_s89 position_props

    join iva.b_iblock_element positions
    on positions.id = position_props.iblock_element_id
  where
    position_props.property_2208 = current_order_id;

end;

