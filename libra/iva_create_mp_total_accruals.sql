create
    definer = iva@`%` procedure iva_create_mp_total_accruals(in current_period_id int)
begin

    update
      iva_mp_accruals accruals

      join iva_extra_profits profits
      on profits.period_id = accruals.period_id
        and profits.user_id = accruals.user_id
    set
      accruals.gb = accruals.gb + profits.gb,
      accruals.lb = accruals.lb + profits.lb,
      accruals.kb = accruals.kb + profits.kb,
      accruals.sb = accruals.sb + profits.sb,
      accruals.bs = accruals.bs + profits.bs
    where
      accruals.period_id = current_period_id;

    update
      iva_mp_accruals accruals
    set
      accruals.points = accruals.ks * (accruals.gb + accruals.lb + accruals.kb + accruals.sb + accruals.bs),
      accruals.money = (accruals.ks * (accruals.gb + accruals.lb + accruals.kb + accruals.sb + accruals.bs) ) * 60
    where
      accruals.period_id = current_period_id;

  end;

