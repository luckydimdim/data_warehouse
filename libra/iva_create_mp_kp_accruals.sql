create
    definer = iva@`%` procedure iva_create_mp_kp_accruals(in current_order_id  int,
                                                          in current_period_id int)
begin


  update
    iva_mp_accruals results

    join iva_mp_transactions bonus
    on bonus.period_id = current_period_id
      and bonus.order_id = current_order_id
      and bonus.target_user_id = results.user_id
  set
    results.ko = results.o1l * 2.5 + results.bo * 1.5
  where
    results.period_id = current_period_id;


  update
    iva_mp_accruals results

    join iva_mp_transactions bonus
    on bonus.period_id = current_period_id
      and bonus.order_id = current_order_id
      and bonus.target_user_id = results.user_id
  set
    results.kp = iva_get_qualification_percent(results.ko),
    results.cmb = iva_get_qualification_percent(results.cmb),
    results.k = iva_get_qualification_id(results.ko)
  where
    results.period_id = current_period_id;


  update
    iva_mp_accruals current

    join iva_mp_accruals previous
    on previous.period_id = current_period_id - 1
      and previous.user_id = current.user_id
  set
    current.cmb = if (iva_get_qualification_percent(previous.ko) > current.cmb, iva_get_qualification_percent(previous.ko), current.cmb)
  where
    current.period_id = current_period_id;


  insert iva_mp_accruals
    (created, period_id, user_id, package_name, go, o1l, osv, bo, ks, ko, kp, cmb, k, lb, kb, bs, gb, sb, points)
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
    0
  from
    iva_mp_accruals previous

    left join iva_mp_accruals current
    on current.period_id = current_period_id
      and current.user_id = previous.user_id
  where
    previous.period_id = current_period_id - 1
    and current.id is null
    and iva_get_qualification_percent(previous.ko) > 0;

end;

