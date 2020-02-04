create
    definer = iva@`%` procedure iva_create_new_period(in current_period_id int)
proc:begin

  if current_period_id is null then
    set current_period_id = iva_get_period_id(null);
  end if;


  insert iva_mp_accruals
    (created, period_id, user_id, package_name, activation)
  select
    iva_get_period_finish(current_period_id),
    current_period_id,
    user_props.id,
    user_props.package_name,
    true
  from
    largo.iva_users user_props

    left join iva_mp_accruals results
    on results.period_id = current_period_id
      and results.user_id = user_props.id
  where
    user_props.permanent_activation = true
    and ( user_props.permanent_activation_till is null
      or user_props.permanent_activation_till >= iva_get_period_finish(current_period_id) )
    and results.id is null;


  insert iva_mp_accruals
    (created, period_id, user_id, package_name, go, o1l, osv, bo, ks, ko, kp, cmb, k, lb, kb, bs, gb, sb, points, money)
  select
    iva_get_period_finish(current_period_id),
    current_period_id,
    previous.user_id,
    previous.package_name,
    0,
    0,
    0,
    0,
    previous.ks,
    0,
    0,
    iva_get_qualification_percent(previous.ko),
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0
  from
    iva_mp_accruals previous
  where
    previous.period_id = current_period_id - 1
    and iva_get_qualification_percent(previous.ko) > 0

  on duplicate key update
    iva_mp_accruals.cmb = iva_get_qualification_percent(previous.ko);


  update
    iva_mp_accruals results
  set
    results.kp = iva_get_qualification_percent(results.ko),
    results.k = iva_get_qualification_id(results.ko)
  where
    results.period_id = current_period_id;


  call largo.iva_create_new_period(current_period_id);
end;

