create
    definer = iva@`%` procedure iva_create_mp_period_orders(in current_period_id int)
begin

  if current_period_id is null then
    set current_period_id = iva_get_period_id(null);
  end if;

  insert iva_mp_orders (
    total_id,
    order_id,
    created,
    period_id,
    user_id,
    user_package_id,
    user_has_business,
    price,
    is_test,
    status,
    accruals_status,
    sequence)
  select
    orders.total_id,
    orders.order_id,
    orders.created,
    orders.period_id,
    orders.user_id,
    orders.user_package_id,
    orders.user_has_business,
    orders.price,
    orders.is_test,
    orders.status,
    orders.accruals_status,
    orders.sequence
  from
    libra.iva_mp_orders orders
  where
    orders.period_id = current_period_id

  on duplicate key update
      largo.iva_mp_orders.total_id = orders.total_id,
      largo.iva_mp_orders.created = orders.created,
      largo.iva_mp_orders.period_id = orders.period_id,
      largo.iva_mp_orders.user_id = orders.user_id,
      largo.iva_mp_orders.user_package_id = orders.user_package_id,
      largo.iva_mp_orders.user_has_business = orders.user_has_business,
      largo.iva_mp_orders.price = orders.price,
      largo.iva_mp_orders.is_test = orders.is_test,
      largo.iva_mp_orders.status = orders.status,
      largo.iva_mp_orders.accruals_status = orders.accruals_status,
      largo.iva_mp_orders.sequence = orders.sequence;

  update
    libra.iva_mp_orders source_orders

    join libra.iva_mp_order_positions positions
    on positions.order_id = source_orders.order_id

    join largo.iva_mp_position_packages packages
    on packages.total_position_id = positions.total_id

    join largo.iva_mp_orders target_orders
    on target_orders.order_id = source_orders.order_id
  set
    target_orders.order_package_id = packages.package_id,
    target_orders.order_package_name = iva_get_package_name(packages.package_id),
    target_orders.order_subscription_in_month = packages.subscription_duration_in_month,
    target_orders.package_price = packages.package_price,
    target_orders.subscription_price = packages.subsription_price
  where
    source_orders.period_id = current_period_id;

end;

