create
    definer = iva@`%` procedure iva_delete_cmb_order_origins(in current_order_id int)
begin

  delete from
    iva.b_iblock_element_prop_s87
  where
    iblock_element_id = current_order_id;

  delete from
    iva.b_iblock_element
  where
    id = current_order_id;

  delete
    extra_accruals,
    extra_accruals_props
  from
    iva.b_iblock_element_prop_s90 extra_accruals_props

    join iva.b_iblock_element extra_accruals
    on extra_accruals.id = extra_accruals_props.iblock_element_id
  where
    extra_accruals_props.property_2216 = current_order_id;

end;

