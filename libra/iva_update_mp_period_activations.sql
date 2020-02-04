create
    definer = iva@`%` procedure iva_update_mp_period_activations(in current_period_id int)
begin

  if current_period_id is null then
    set current_period_id = iva_get_period_id(null);
  end if;

  insert iva_mp_accruals
    (created, period_id, user_id, package_name, activation)
  select
    iva_get_period_finish(current_period_id),
    current_period_id,
    orders.user_id,
    users.package_name,
    true
  from
    iva_mp_orders orders

    join iva_users users
    on users.user_id = orders.user_id

    left join iva_mp_accruals results
    on results.period_id = current_period_id
      and results.user_id = orders.user_id
  where
    orders.period_id = current_period_id
    and orders.status in ('new', 'completed')
    and results.id is null
  group by
    orders.user_id
  having
    sum(orders.price) >= 6000;

  update
    iva_mp_accruals results

    join (
      select
        sum(order_props.price) >= 6000 value,
        order_props.user_id user_id
      from
        iva_mp_orders order_props
      where
        order_props.period_id = current_period_id
        and order_props.status in ('new', 'completed')
      group by
        order_props.user_id) activation
      on activation.user_id = results.user_id
  set
    results.activation = activation.value
  where
    results.period_id = current_period_id;

end;

