create
    definer = iva@`%` procedure iva_create_cmb_period_orders(in current_period_id int)
begin

  if current_period_id is null then
    set current_period_id = iva_get_period_id(null);
  end if;

  insert iva_cmb_orders (
    order_id,
    order_number,
    name,
    status,
    period_id,
    created,
    user_id,
    base_price,
    price,
    partial_payment_status,
    utm_source,
    utm_medium,
    utm_campaign,
    utm_term,
    utm_content)
  select
    order_props.iblock_element_id,
    order_props.property_2193,
    left(order_props.property_2182, 255),
    lower(order_props.property_2196),
    order_props.property_2198,
    order_props.property_2197,
    order_props.property_2170,
    order_props.property_2171,
    order_props.property_2173,
    lower(order_props.property_2195),
    ifnull(order_props.property_2202, ''),
    ifnull(order_props.property_2203, ''),
    ifnull(order_props.property_2204, ''),
    ifnull(order_props.property_2205, ''),
    ifnull(order_props.property_2206, '')
  from
    iva.b_iblock_element_prop_s87 order_props
  where
    order_props.property_2198 = current_period_id

  on duplicate key update
      libra.iva_cmb_orders.order_number = order_props.property_2193,
      libra.iva_cmb_orders.name = order_props.property_2182,
      libra.iva_cmb_orders.status = lower(order_props.property_2196),
      libra.iva_cmb_orders.period_id = order_props.property_2198,
      libra.iva_cmb_orders.created = order_props.property_2197,
      libra.iva_cmb_orders.user_id = order_props.property_2170,
      libra.iva_cmb_orders.base_price = order_props.property_2171,
      libra.iva_cmb_orders.price = order_props.property_2173,
      libra.iva_cmb_orders.partial_payment_status = lower(order_props.property_2195),
      libra.iva_cmb_orders.utm_source = ifnull(order_props.property_2202, ''),
      libra.iva_cmb_orders.utm_medium = ifnull(order_props.property_2203, ''),
      libra.iva_cmb_orders.utm_campaign = ifnull(order_props.property_2204, ''),
      libra.iva_cmb_orders.utm_term = ifnull(order_props.property_2205, ''),
      libra.iva_cmb_orders.utm_content = ifnull(order_props.property_2206, '');

    insert iva_cmb_extra_accruals
      (order_id, type, user_id, value, created, period_id, status)
    select
      property_2216,
      property_2217,
      ifnull(property_2218, 0),
      property_2219,
      property_2220,
      property_2222,
      'new'
    from
      iva.b_iblock_element_prop_s90
    where
      property_2222 = current_period_id
      and property_2216 is not null

    on duplicate key update
      iva_cmb_extra_accruals.user_id = ifnull(property_2218, 0),
      iva_cmb_extra_accruals.value = property_2219,
      iva_cmb_extra_accruals.created = property_2220,
      iva_cmb_extra_accruals.period_id = property_2222,
      iva_cmb_extra_accruals.status = property_2221;


    call largo.iva_create_cmb_period_orders(current_period_id);

end;

