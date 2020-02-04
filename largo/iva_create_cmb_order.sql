create
    definer = iva@`%` procedure iva_create_cmb_order(in current_order_id int)
begin
    insert largo.iva_cmb_orders (
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
      orders.order_id,
      orders.order_number,
      orders.name,
      orders.status,
      orders.period_id,
      orders.created,
      orders.user_id,
      orders.base_price,
      orders.price,
      orders.partial_payment_status,
      orders.utm_source,
      orders.utm_medium,
      orders.utm_campaign,
      orders.utm_term,
      orders.utm_content
    from
      libra.iva_cmb_orders orders
    where
      orders.order_id = current_order_id

  on duplicate key update
      largo.iva_cmb_orders.order_number = orders.order_number,
      largo.iva_cmb_orders.name = orders.name,
      largo.iva_cmb_orders.status = orders.status,
      largo.iva_cmb_orders.period_id = orders.period_id,
      largo.iva_cmb_orders.created = orders.created,
      largo.iva_cmb_orders.user_id = orders.user_id,
      largo.iva_cmb_orders.base_price = orders.base_price,
      largo.iva_cmb_orders.price = orders.price,
      largo.iva_cmb_orders.partial_payment_status = orders.partial_payment_status,
      largo.iva_cmb_orders.utm_source = orders.utm_source,
      largo.iva_cmb_orders.utm_medium = orders.utm_medium,
      largo.iva_cmb_orders.utm_campaign = orders.utm_campaign,
      largo.iva_cmb_orders.utm_term = orders.utm_term,
      largo.iva_cmb_orders.utm_content = orders.utm_content;
end;

