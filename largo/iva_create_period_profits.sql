create
    definer = iva@`%` procedure iva_create_period_profits(in current_period_id int)
begin

  if current_period_id is null then
    set current_period_id = iva_get_period_id(null);
  end if;

  call largo.iva_delete_period_profits(current_period_id);

  insert largo.iva_profits (
    user_id, period_id, period_name, activation, go, o1l, osv, bo, ko, k, qualification_name,
    kp, ks, cmb, lb, kb, bs, gb, sb, mp_points, mp_money, cmb_points, cmb_money, extra_points, extra_money, extra_name, total_points, total_money, available_amount)
  select
    users.id,
    current_period_id,
    iva_get_period_name_by_id(current_period_id),
    ifnull(mp_results.activation, 0),
    ifnull(mp_results.go, 0),
    ifnull(mp_results.o1l, 0),
    ifnull(mp_results.osv, 0),
    ifnull(mp_results.bo, 0),
    ifnull(mp_results.ko, 0),
    ifnull(mp_results.k, 0),
    iva_get_qualification_name(mp_results.k),
    ifnull(mp_results.kp, 0),
    ifnull(mp_results.ks, 0),
    ifnull(mp_results.cmb, 0),
    ifnull(mp_results.lb, 0),
    ifnull(mp_results.kb, 0),
    ifnull(mp_results.bs, 0),
    ifnull(mp_results.gb, 0),
    ifnull(mp_results.sb, 0),
    ifnull(mp_results.points, 0),
    ifnull(mp_results.money, 0),
    ifnull(cmb_results.points, 0),
    ifnull(cmb_results.money, 0),
    ifnull(extra_profits.mp_points, 0) + ifnull(extra_profits.cmb_points, 0),
    (ifnull(extra_profits.mp_points, 0) + ifnull(extra_profits.cmb_points, 0)) * 60,
    ifnull(extra_profits.comment, 'Дополнительное вознаграждение'),
    ifnull(mp_results.points, 0) + ifnull(cmb_results.points, 0) + ifnull(extra_profits.mp_points, 0) + ifnull(extra_profits.cmb_points, 0),
    ifnull(mp_results.money, 0) + ifnull(cmb_results.money, 0) + ((ifnull(extra_profits.mp_points, 0) + ifnull(extra_profits.cmb_points, 0)) * 60),
    iva_get_available_balance(mp_results.user_id)
  from
    largo.iva_users users

    left join libra.iva_mp_accruals mp_results
    on mp_results.period_id = current_period_id
      and mp_results.user_id = users.id

    join largo.iva_periods periods
    on periods.id = current_period_id

    left join libra.iva_cmb_accruals cmb_results
    on cmb_results.period_id = current_period_id
      and cmb_results.user_id = users.id

    left join libra.iva_extra_profits extra_profits
    on extra_profits.period_id = current_period_id
      and extra_profits.user_id = users.id
  where
    ifnull(cmb_results.points, 0) > 0 or ifnull(mp_results.points, 0) > 0

  on duplicate key update
    largo.iva_profits.activation = ifnull(mp_results.activation, 0),
    largo.iva_profits.go = ifnull(mp_results.go, 0),
    largo.iva_profits.o1l = ifnull(mp_results.o1l, 0),
    largo.iva_profits.osv = ifnull(mp_results.osv, 0),
    largo.iva_profits.bo = ifnull(mp_results.bo, 0),
    largo.iva_profits.ko = ifnull(mp_results.ko, 0),
    largo.iva_profits.k = ifnull(mp_results.k, 0),
    largo.iva_profits.qualification_name = iva_get_qualification_name(mp_results.k),
    largo.iva_profits.kp = ifnull(mp_results.kp, 0),
    largo.iva_profits.ks = ifnull(mp_results.ks, 0),
    largo.iva_profits.cmb = ifnull(mp_results.cmb, 0),
    largo.iva_profits.lb = ifnull(mp_results.lb, 0),
    largo.iva_profits.kb = ifnull(mp_results.kb, 0),
    largo.iva_profits.bs = ifnull(mp_results.bs, 0),
    largo.iva_profits.gb = ifnull(mp_results.gb, 0),
    largo.iva_profits.sb = ifnull(mp_results.sb, 0),
    largo.iva_profits.mp_points = ifnull(mp_results.points, 0),
    largo.iva_profits.mp_money = ifnull(mp_results.money, 0),
    largo.iva_profits.cmb_points = ifnull(cmb_results.points, 0),
    largo.iva_profits.cmb_money = ifnull(cmb_results.money, 0),
    largo.iva_profits.extra_points = ifnull(extra_profits.mp_points, 0) + ifnull(extra_profits.cmb_points, 0),
    largo.iva_profits.extra_money = (ifnull(extra_profits.mp_points, 0) + ifnull(extra_profits.cmb_points, 0)) * 60,
    largo.iva_profits.extra_name = ifnull(extra_profits.comment, 'Дополнительное вознаграждение'),
    largo.iva_profits.total_points = ifnull(mp_results.points, 0) + ifnull(cmb_results.points, 0) + ifnull(extra_profits.mp_points, 0) + ifnull(extra_profits.cmb_points, 0),
    largo.iva_profits.total_money = ifnull(mp_results.money, 0) + ifnull(cmb_results.money, 0) + ((ifnull(extra_profits.mp_points, 0) + ifnull(extra_profits.cmb_points, 0)) * 60),
    largo.iva_profits.available_amount = iva_get_available_balance(mp_results.user_id);

end;

