create
    definer = iva@`%` procedure iva_update_cmb_user_branches(in current_period_id int)
begin

  if current_period_id is null then
    set current_period_id = iva_get_period_id(null);
  end if;

    update
      iva_user_branches summary

      join iva_profits results
      on results.user_id = summary.child_id
        and results.period_id = current_period_id
    set
      summary.cmb_points = results.cmb_points,
      summary.cmb_money = results.cmb_money,
      summary.total_points = summary.mp_points + results.cmb_points,
      summary.total_money = summary.mp_money + results.cmb_money
    where
      summary.is_trash = false;

  end;

