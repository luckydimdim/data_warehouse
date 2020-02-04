create
    definer = iva@`%` procedure iva_create_report_mp_period_accruals_extended(in current_period_id int)
begin
  if current_period_id is null then
    set current_period_id = iva_get_period_id(null);
  end if;

  select
    bonus.order_id,
    iva_format_date(bonus.created, false) order_date,
    payment_props.total_id,
    child.id child_id,
    child.name child_name,
    child.surname child_surname,
    child.email child_email,
    ifnull(child_results.activation, 0) child_activation,
    bonus.source_package_name child_package_name,
    parent.id parent_id,
    parent.name parent_name,
    parent.surname parent_surname,
    parent.email parent_email,
    ifnull(parent_results.activation, 0) parent_activation,
    bonus.target_package_name parent_package_name,
    bonus.go_package points,
    bonus.go_package * 60 rub
  from
    iva_mp_transactions bonus

    join largo.iva_users child
    on child.id = bonus.source_user_id

    left join iva_mp_accruals child_results
    on child_results.period_id = current_period_id
      and child_results.user_id = child.id

    join largo.iva_users parent
    on parent.id = bonus.target_user_id

    left join iva_mp_accruals parent_results
    on parent_results.period_id = current_period_id
      and parent_results.user_id = parent.id

    join iva_mp_orders payment_props
    on payment_props.period_id = current_period_id
      and payment_props.order_id = bonus.order_id
      and payment_props.status = 'completed'
  where
    bonus.period_id = current_period_id
    and bonus.status = 'completed'
    and child.id not in (1, 2)
    and parent.id not in (1, 2)
  order by
    bonus.created asc;

end;

