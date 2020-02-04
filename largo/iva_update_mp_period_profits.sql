create
    definer = iva@`%` procedure iva_update_mp_period_profits(in current_period_id int)
begin

  if current_period_id is null then
    set current_period_id = iva_get_period_id(null);
  end if;

  insert largo.iva_profits (
    user_id, period_id, period_name, activation, go, o1l, osv, bo, ko, k, qualification_name,
    kp, ks, cmb, lb, kb, bs, gb, sb, mp_points, mp_money, cmb_points, cmb_money, extra_points, extra_money, extra_name, total_points, total_money, available_amount)
  select
    mp_results.user_id,
    mp_results.period_id,
    periods.name,
    mp_results.activation,
    mp_results.go,
    mp_results.o1l,
    mp_results.osv,
    mp_results.bo,
    mp_results.ko,
    mp_results.k,
    iva_get_qualification_name(mp_results.k),
    mp_results.kp,
    mp_results.ks,
    mp_results.cmb,
    mp_results.lb,
    mp_results.kb,
    mp_results.bs,
    mp_results.gb,
    mp_results.sb,
    mp_results.points,
    mp_results.money,
    ifnull(cmb_results.points, 0),
    ifnull(cmb_results.money, 0),
    ifnull(extra_profits.mp_points, 0) + ifnull(extra_profits.cmb_points, 0),
    (ifnull(extra_profits.mp_points, 0) + ifnull(extra_profits.cmb_points, 0)) * 60,
    ifnull(extra_profits.comment, 'Дополнительное вознаграждение'),
    mp_results.points + ifnull(cmb_results.points, 0) + ifnull(extra_profits.mp_points, 0) + ifnull(extra_profits.cmb_points, 0),
    mp_results.money + ifnull(cmb_results.money, 0) + ((ifnull(extra_profits.mp_points, 0) + ifnull(extra_profits.cmb_points, 0)) * 60),
    iva_get_available_balance(mp_results.user_id)
  from
    libra.iva_mp_transactions bonuses

    join libra.iva_mp_accruals mp_results
    on mp_results.period_id = bonuses.period_id
      and mp_results.user_id = bonuses.target_user_id

    join iva_periods periods
    on periods.id = bonuses.period_id

    left join libra.iva_cmb_accruals cmb_results
    on cmb_results.period_id = bonuses.period_id
      and cmb_results.user_id = bonuses.target_user_id

    left join libra.iva_extra_profits extra_profits
    on extra_profits.period_id = current_period_id
      and extra_profits.user_id = bonuses.target_user_id
  where
    bonuses.period_id = current_period_id

  on duplicate key update
    largo.iva_profits.user_id = mp_results.user_id,
    largo.iva_profits.period_id = mp_results.period_id,
    largo.iva_profits.period_name = periods.name,
    largo.iva_profits.activation = mp_results.activation,
    largo.iva_profits.go = mp_results.go,
    largo.iva_profits.o1l = mp_results.o1l,
    largo.iva_profits.osv = mp_results.osv,
    largo.iva_profits.bo = mp_results.bo,
    largo.iva_profits.ko = mp_results.ko,
    largo.iva_profits.k = mp_results.k,
    largo.iva_profits.qualification_name = iva_get_qualification_name(mp_results.k),
    largo.iva_profits.kp = mp_results.kp,
    largo.iva_profits.ks = mp_results.ks,
    largo.iva_profits.cmb = mp_results.cmb,
    largo.iva_profits.lb = mp_results.lb,
    largo.iva_profits.kb = mp_results.kb,
    largo.iva_profits.bs = mp_results.bs,
    largo.iva_profits.gb = mp_results.gb,
    largo.iva_profits.sb = mp_results.sb,
    largo.iva_profits.mp_points = mp_results.points,
    largo.iva_profits.mp_money = mp_results.money,
    largo.iva_profits.cmb_points = ifnull(cmb_results.points, 0),
    largo.iva_profits.cmb_money = ifnull(cmb_results.money, 0),
    largo.iva_profits.extra_points = ifnull(extra_profits.mp_points, 0) + ifnull(extra_profits.cmb_points, 0),
    largo.iva_profits.extra_money = (ifnull(extra_profits.mp_points, 0) + ifnull(extra_profits.cmb_points, 0)) * 60,
    largo.iva_profits.extra_name = ifnull(extra_profits.comment, 'Дополнительное вознаграждение'),
    largo.iva_profits.total_points = mp_results.points + ifnull(cmb_results.points, 0) + ifnull(extra_profits.mp_points, 0) + ifnull(extra_profits.cmb_points, 0),
    largo.iva_profits.total_money = mp_results.money + ifnull(cmb_results.money, 0) + ((ifnull(extra_profits.mp_points, 0) + ifnull(extra_profits.cmb_points, 0)) * 60),
    largo.iva_profits.available_amount = iva_get_available_balance(mp_results.user_id);
end;

