create
    definer = iva@`%` procedure iva_create_report_mp_period_accruals(in current_period_id int)
begin
  if current_period_id is null then
    set current_period_id = iva_get_period_id(null);
  end if;

  select
    users.id,
    users.email,
    users.name,
    users.surname,
    results.package_name,
    results.activation,
    results.go,
    results.o1l,
    results.osv,
    results.bo,
    results.ks,
    results.ko,
    results.kp,
    results.cmb,
    iva_get_qualification_name(results.k) k,
    results.lb,
    results.kb,
    results.bs,
    results.gb,
    results.sb,
    results.points,
    results.money rub
  from
    iva_mp_accruals results

    join largo.iva_users users
    on users.id = results.user_id

    left join iva_mp_orders orders
    on orders.period_id = current_period_id
      and orders.status = 'completed'
      and orders.user_id = users.id
  where
    results.period_id = current_period_id
    and results.points <> 0
    and results.user_id not in (1, 2)
  group by
    results.user_id
  order by
    users.id asc;

end;

