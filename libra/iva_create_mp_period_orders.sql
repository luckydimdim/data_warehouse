create
    definer = iva@`%` procedure iva_create_mp_period_orders(in current_period_id int)
begin

  if current_period_id is null then
    set current_period_id = iva_get_period_id(null);
  end if;

  insert iva_mp_orders
    (order_id, total_id, user_id, user_package_id, user_has_business, created, period_id, accruals_status, status, price)
  select
    order_props.iblock_element_id,
    order_props.property_2207,
    users.id,
    users.package_id,
    users.has_business,
    order_props.property_2200,
    order_props.property_2199,
    'n',
    'new',
    order_props.property_2016
  from
    iva.b_iblock_element_prop_s74 order_props

    join largo.iva_users users
    on users.id = order_props.property_2015
  where
    order_props.property_2199 = current_period_id

  on duplicate key update
    iva_mp_orders.total_id = order_props.property_2207,
    iva_mp_orders.user_id = users.id,
    iva_mp_orders.user_package_id = users.package_id,
    iva_mp_orders.user_has_business = users.has_business,
    iva_mp_orders.created = order_props.property_2200,
    iva_mp_orders.period_id = order_props.property_2199,
    iva_mp_orders.accruals_status = 'n',
    iva_mp_orders.status = 'new';

  call iva_create_mp_period_order_positions(current_period_id);


  call largo.iva_create_mp_period_orders(current_period_id);
end;

