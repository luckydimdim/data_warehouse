create
    definer = iva@`%` procedure iva_update_mp_period_branches(in current_period_id int)
begin

  if current_period_id is null then
    set current_period_id = iva_get_period_id(null);
  end if;


    update
      iva_user_branches summary

      join iva_users users
      on users.id = summary.child_id

      join libra.iva_mp_accruals results
      on results.user_id = summary.child_id
        and results.period_id = current_period_id
    set
      summary.package_id = users.package_id,
      summary.package_name = iva_get_package_name(users.package_id),
      summary.subscription_expire = users.package_expires,
      summary.is_subscription_expired = if (users.package_expires is not null and users.package_expires > now(), false, true),
      summary.activation = results.activation,
      summary.go = results.go,
      summary.o1l = results.o1l,
      summary.osv = results.osv,
      summary.bo = results.bo,
      summary.ko = results.ko,
      summary.k = results.k,
      summary.qualification_name = iva_get_qualification_name(results.k),
      summary.kp = results.kp,
      summary.ks = results.ks,
      summary.cmb = results.cmb,
      summary.lb = results.lb,
      summary.kb = results.kb,
      summary.bs = results.bs,
      summary.gb = results.gb,
      summary.sb = results.sb,
      summary.mp_points = results.points,
      summary.mp_money = results.money,
      summary.total_points = results.points + summary.cmb_points,
      summary.total_money = results.money + summary.cmb_money
    where
      summary.is_trash = false;

  end;

