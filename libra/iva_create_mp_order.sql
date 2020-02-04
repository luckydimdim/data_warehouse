create
    definer = iva@`%` procedure iva_create_mp_order(in current_order_id int)
begin

  insert iva_mp_orders
    (order_id, total_id, user_id, user_package_id, user_has_business, created, period_id, price)
  select
    order_props.iblock_element_id,
    order_props.property_2207,
    users.id,
    users.package_id,
    users.has_business,
    order_props.property_2200,
    order_props.property_2199,
    order_props.property_2016
  from
    iva.b_iblock_element_prop_s74 order_props

    join largo.iva_users users
    on users.id = order_props.property_2015
  where
    order_props.iblock_element_id = current_order_id

  on duplicate key update
    iva_mp_orders.total_id = order_props.property_2207,
    iva_mp_orders.user_id = users.id,
    iva_mp_orders.user_package_id = users.package_id,
    iva_mp_orders.user_has_business = users.has_business,
    iva_mp_orders.created = order_props.property_2200,
    iva_mp_orders.period_id = order_props.property_2199;

  call iva_create_mp_order_positions(current_order_id);
end;

