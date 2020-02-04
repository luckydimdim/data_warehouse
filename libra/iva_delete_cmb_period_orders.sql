create
    definer = iva@`%` procedure iva_delete_cmb_period_orders(in current_period_id int)
begin

  if current_period_id is null then
    set current_period_id = iva_get_period_id(null);
  end if;

  delete from
    iva_cmb_orders
  where
    period_id = current_period_id;

  delete from
    iva_cmb_extra_accruals
  where
    period_id = current_period_id;

  update
    iva.b_iblock_element_prop_s90
  set
    property_2221 = 'new'
  where
    property_2222 = current_period_id;


  call largo.iva_delete_cmb_period_orders(current_period_id);

end;

