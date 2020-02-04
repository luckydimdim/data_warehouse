create
    definer = iva@`%` procedure iva_create_new_period(in current_period_id int)
begin

  if current_period_id is null then
    set current_period_id = iva_get_period_id(null);
  end if;

  update
    iva_user_branches
  set
    activation = false,
    kp = 0,
    cmb = 0,
    k = 0,
    qualification_name = iva_get_qualification_name(0),
    cmb_points = 0,
    cmb_money = 0,
    mp_points = 0,
    mp_money = 0,
    total_points = 0,
    total_money = 0
  where
    is_trash = false
    and (activation = true or cmb <> 0 or total_money <> 0);

  update
    iva_user_branches parents_children

    join libra.iva_mp_accruals results
    on results.period_id = current_period_id
      and results.user_id = parents_children.child_id
  set
    parents_children.kp = results.kp,
    parents_children.cmb = results.cmb,
    parents_children.k = results.k,
    parents_children.qualification_name = iva_get_qualification_name(results.k)
  where
    parents_children.is_trash = false;

  insert iva_profits (
    user_id, period_id, period_name, activation, go, o1l, osv, bo, ko, k, qualification_name,
    kp, ks, cmb, lb, kb, bs, gb, sb, mp_points, mp_money, cmb_points, cmb_money, total_points, total_money)
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
    mp_results.points + ifnull(cmb_results.points, 0),
    mp_results.money + ifnull(cmb_results.money, 0)
  from
    libra.iva_mp_accruals mp_results

    join iva_periods periods
    on periods.id = mp_results.period_id

    left join libra.iva_cmb_accruals cmb_results
    on cmb_results.period_id = mp_results.period_id
      and cmb_results.user_id = mp_results.user_id
  where
    mp_results.period_id = current_period_id

  on duplicate key update
    largo.iva_profits.cmb = mp_results.cmb;

    call iva_create_user_totals_cancel();
    call iva_update_user_totals(current_period_id);
end;

