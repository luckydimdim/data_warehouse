create
    definer = iva@`%` procedure iva_create_report_cmb_period_sales_report(in current_period_id int)
begin
  if current_period_id is null then
    set current_period_id = iva_get_period_id(null);
  end if;

  select
    payment_props.order_id,
    payment_props.order_number gc_order_id,
    iva_format_date(payment_props.created, false) order_date,
    users.id,
    users.email,
    users.name,
    users.surname,
    ifnull(results.activation, 0) activation,
    payment_props.name product_name,
    payment_props.base_price,
    payment_props.price,
    if (payment_props.partial_payment_status = 'has_parts', 'Частично оплачен', '') partial
  from
    iva_cmb_orders payment_props

    join largo.iva_users users
    on users.id = payment_props.user_id

    left join iva_mp_accruals results
    on results.user_id = users.id
      and results.period_id = current_period_id

    left join iva_cmb_excepted_positions exceptions
    on payment_props.name like concat(exceptions.name, '%')
  where
    payment_props.period_id = current_period_id
    and payment_props.base_price > 0
    and payment_props.status = 'completed'
    and users.id not in (1, 2)
    and exceptions.id is null
  order by
    payment_props.created asc;

end;

