create
    definer = iva@`%` procedure iva_update_cmb_period_profits(in current_period_id int)
begin

  if current_period_id is null then
    set current_period_id = iva_get_period_id(null);
  end if;

  call iva_create_cmb_period_profits_cancel(current_period_id);

  update
    largo.iva_profits profits

    join (
      select
        target_user_id user_id,
        sum(points) points,
        sum(price) money
      from
        libra.iva_cmb_transactions
      where
        period_id = current_period_id
      group by
        target_user_id) cmb_results
    on cmb_results.user_id = profits.user_id

    join iva_periods periods
    on periods.id = profits.period_id

    left join iva_profits mp_results
    on mp_results.period_id = profits.period_id
      and mp_results.user_id = profits.user_id

    left join libra.iva_extra_profits extra_profits
    on extra_profits.period_id = current_period_id
      and extra_profits.user_id = profits.user_id
  set
    profits.cmb_points = cmb_results.points,
    profits.cmb_money = cmb_results.money,
    profits.extra_points = ifnull(extra_profits.mp_points, 0) + ifnull(extra_profits.cmb_points, 0),
    profits.extra_money = (ifnull(extra_profits.mp_points, 0) + ifnull(extra_profits.cmb_points, 0)) * 60,
    profits.extra_name = ifnull(extra_profits.comment, 'Дополнительное вознаграждение'),
    profits.total_points = ifnull(mp_results.mp_points, 0) + cmb_results.points + ifnull(extra_profits.mp_points, 0) + ifnull(extra_profits.cmb_points, 0),
    profits.total_money = ifnull(mp_results.mp_money, 0) + cmb_results.money + ((ifnull(extra_profits.mp_points, 0) + ifnull(extra_profits.cmb_points, 0)) * 60)
  where
    profits.period_id = current_period_id;

end;

