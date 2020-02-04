create
    definer = iva@`%` procedure iva_create_report_mp_period_sales_report(in current_period_id int)
begin
  if current_period_id is null then
    set current_period_id = iva_get_period_id(null);
  end if;

  select
    payment_props.order_id,
    payment_props.total_id order_number,
    users.id user_id,
    concat_ws(' ', users.name, users.surname) user_name,
    users.email user_email,
    ifnull(results.activation, false) activation,
    users.package_name package_name,
    iva_format_date(users.package_expires, true) package_till,
    iva_format_date(payment_props.created, false) pay_date,
    group_concat(concat(positions.name, ' x ', positions.quantity, ' (', positions.amount, ' р.)') separator ' | ') positions,
    positions.quantity positions_quantity,
    payment_props.price,
    payment_props.status,
    payment_props.period_id
  from
    iva_mp_orders payment_props

    join largo.iva_users users
    on users.id = payment_props.user_id

    left join iva_mp_order_positions positions
    on positions.order_id = payment_props.order_id

    left join largo.iva_mp_position_packages packages
    on packages.total_position_id = positions.total_id

    left join iva_mp_accruals results
    on results.user_id = users.id
      and results.period_id = current_period_id
  where
    payment_props.period_id = current_period_id
    and payment_props.status = 'completed'
    and users.id not in (1, 2)
  group by
    payment_props.order_id
  order by
    payment_props.created asc;

end;

