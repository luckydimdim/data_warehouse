create
    definer = iva@`%` procedure iva_update_cmb_order_profits(in current_order_id  int,
                                                             in current_period_id int)
begin

  if current_period_id is null then
    set current_period_id = iva_get_period_id(null);
  end if;

  insert iva_profits (
    user_id, period_id, period_name, activation, go, o1l, osv, bo, ko, k, qualification_name,
    kp, ks, cmb, lb, kb, bs, gb, sb, mp_points, mp_money, cmb_points, cmb_money, extra_points, extra_money, extra_name, total_points, total_money, available_amount)
  select
    cmb_results.user_id,
    cmb_results.period_id,
    periods.name,
    ifnull(mp_results.activation, false),
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
    ifnull(mp_results.mp_points, 0),
    ifnull(mp_results.mp_money, 0),
    cmb_results.points,
    cmb_results.money,
    ifnull(extra_profits.mp_points, 0) + ifnull(extra_profits.cmb_points, 0),
    (ifnull(extra_profits.mp_points, 0) + ifnull(extra_profits.cmb_points, 0)) * 60,
    ifnull(extra_profits.comment, 'Дополнительное вознаграждение'),
    ifnull(mp_results.mp_points, 0) + cmb_results.points + ifnull(extra_profits.mp_points, 0) + ifnull(extra_profits.cmb_points, 0),
    ifnull(mp_results.mp_money, 0) + cmb_results.money + ((ifnull(extra_profits.mp_points, 0) + ifnull(extra_profits.cmb_points, 0)) * 60),
    iva_get_available_balance(cmb_results.user_id)
  from
    libra.iva_cmb_transactions bonuses

    join libra.iva_cmb_accruals cmb_results
    on cmb_results.period_id = bonuses.period_id
      and cmb_results.user_id = bonuses.target_user_id

    join iva_periods periods
    on periods.id = bonuses.period_id

    left join iva_profits mp_results
    on mp_results.period_id = bonuses.period_id
      and mp_results.user_id = bonuses.target_user_id

    left join libra.iva_extra_profits extra_profits
    on extra_profits.period_id = current_period_id
      and extra_profits.user_id = bonuses.target_user_id
  where
    bonuses.period_id = current_period_id
    and bonuses.order_id = current_order_id
    and bonuses.status = 'completed'

  on duplicate key update
    largo.iva_profits.user_id = cmb_results.user_id,
    largo.iva_profits.period_id = cmb_results.period_id,
    largo.iva_profits.period_name = periods.name,
    largo.iva_profits.activation = ifnull(mp_results.activation, false),
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
    largo.iva_profits.mp_points = ifnull(mp_results.mp_points, 0),
    largo.iva_profits.mp_money = ifnull(mp_results.mp_money, 0),
    largo.iva_profits.cmb_points = cmb_results.points,
    largo.iva_profits.cmb_money = cmb_results.money,
    largo.iva_profits.extra_points = ifnull(extra_profits.mp_points, 0) + ifnull(extra_profits.cmb_points, 0),
    largo.iva_profits.extra_money = (ifnull(extra_profits.mp_points, 0) + ifnull(extra_profits.cmb_points, 0)) * 60,
    largo.iva_profits.extra_name = ifnull(extra_profits.comment, 'Дополнительное вознаграждение'),
    largo.iva_profits.total_points = ifnull(mp_results.mp_points, 0) + cmb_results.points + ifnull(extra_profits.mp_points, 0) + ifnull(extra_profits.cmb_points, 0),
    largo.iva_profits.total_money = ifnull(mp_results.mp_money, 0) + cmb_results.money + ((ifnull(extra_profits.mp_points, 0) + ifnull(extra_profits.cmb_points, 0)) * 60),
    largo.iva_profits.available_amount = iva_get_available_balance(cmb_results.user_id);

end;

