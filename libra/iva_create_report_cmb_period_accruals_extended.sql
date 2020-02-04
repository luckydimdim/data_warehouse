create
    definer = iva@`%` procedure iva_create_report_cmb_period_accruals_extended(in current_period_id int)
begin
  if current_period_id is null then
    set current_period_id = iva_get_period_id(null);
  end if;

  select
    cmb.order_id,
    orders.order_number,
    iva_format_date(cmb.created, false) datetime,
    orders.name offer_name,
    source.id source_id,
    source.email source_email,
    source.name source_name,
    source.surname source_surname,
    ifnull(source_results.activation, 0) source_activation,
    target.id target_id,
    target.email target_email,
    target.name target_name,
    target.surname target_surname,
    ifnull(target_results.activation, 0) target_activation,
    orders.base_price,
    orders.price amount,
    cmb.points,
    cmb.price,
    if (orders.partial_payment_status = 'has_parts', 'Частично оплачен', '') partial,
    cmb.comment
  from
    iva_cmb_transactions cmb

    join largo.iva_users source
    on source.id = cmb.source_user_id

    join largo.iva_users target
    on target.id = cmb.target_user_id

    join iva_cmb_orders orders
    on orders.period_id = current_period_id
      and orders.order_id = cmb.order_id

    left join iva_mp_accruals source_results
    on source_results.period_id = current_period_id
      and source_results.user_id = source.id

    left join iva_mp_accruals target_results
    on target_results.period_id = current_period_id
      and target_results.user_id = target.id
  where
    cmb.period_id = current_period_id
    and orders.price <> 0
    and source.id not in (1, 2)
    and target.id not in (1, 2)
  order by
    cmb.order_id asc;
end;

