create
    definer = iva@`%` procedure iva_delete_cmb_order(in current_order_id int)
begin

  declare current_period_id int;

  set current_period_id = (
    select
      period_id
    from
      iva_cmb_orders
    where
      order_id = current_order_id);

  delete from
    iva_cmb_orders
  where
    order_id = current_order_id;

  delete from
    iva_cmb_extra_accruals
  where
    order_id = current_order_id;

  update
    iva.b_iblock_element_prop_s90
  set
    property_2221 = 'new'
  where
    property_2222 = current_period_id
    and property_2216 = current_order_id;


  call largo.iva_delete_cmb_order(current_order_id);
end;

