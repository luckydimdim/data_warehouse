create
    definer = iva@`%` procedure iva_update_cmb_order(in current_order_id int)
begin
  update
    iva_cmb_orders orders

    join iva.b_iblock_element_prop_s87 payment_props
    on payment_props.iblock_element_id = orders.order_id
  set
    order_id = payment_props.iblock_element_id,
    order_number = payment_props.property_2193,
    name = payment_props.property_2182,
    status = lower(payment_props.property_2196),
    period_id = payment_props.property_2198,
    created = payment_props.property_2197,
    user_id = payment_props.property_2170,
    base_price = payment_props.property_2171,
    price = payment_props.property_2173,
    partial_payment_status = lower(payment_props.property_2195),
    utm_source = ifnull(payment_props.property_2202, ''),
    utm_medium = ifnull(payment_props.property_2203, ''),
    utm_campaign = ifnull(payment_props.property_2204, ''),
    utm_term = ifnull(payment_props.property_2205, ''),
    utm_content = ifnull(payment_props.property_2206, '')
  where
    orders.order_id = current_order_id;

  insert iva_cmb_extra_accruals
    (order_id, type, user_id, value, created, period_id)
  select
    property_2216,
    property_2217,
    ifnull(property_2218, 0),
    property_2219,
    property_2220,
    property_2222
  from
    iva.b_iblock_element_prop_s90
  where
    property_2216 = current_order_id

  on duplicate key update
    iva_cmb_extra_accruals.user_id = ifnull(property_2218, 0),
    iva_cmb_extra_accruals.value = property_2219,
    iva_cmb_extra_accruals.created = property_2220,
    iva_cmb_extra_accruals.period_id = property_2222;


    call largo.iva_update_cmb_order(current_order_id);
end;

