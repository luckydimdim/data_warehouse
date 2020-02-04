create
    definer = iva@`%` procedure iva_create_report_cmb_period_missing_orders(in current_period_id int)
begin

  if current_period_id is null then
    set current_period_id = iva_get_period_id(null);
  end if;

  select
    payment_props.iblock_element_id order_id,
    concat('call iva_create_cmb_order(', payment_props.iblock_element_id, ');') create_order,
    concat('call iva_create_cmb_accruals(', payment_props.iblock_element_id, ', ', current_period_id, ');') create_accruals
  from
    iva.b_iblock_element_prop_s87 payment_props

    left join largo.iva_cmb_orders orders
    on orders.period_id = current_period_id
      and orders.order_id = payment_props.iblock_element_id
  where
    payment_props.property_2198 = current_period_id
    and (orders.id is null or payment_props.property_2170 <> orders.user_id);
end;

