create
    definer = iva@`%` procedure iva_create_report_cmb_period_accruals(in current_period_id int)
begin

  if current_period_id is null then
    set current_period_id = iva_get_period_id(null);
  end if;

  select
    user.id,
    user.email,
    user.name,
    user.surname,
    ifnull(results.activation, 0) activation,
    cmb.points,
    cmb.money
  from
    iva_cmb_accruals cmb

    join largo.iva_users user
    on user.id = cmb.user_id

    left join iva_mp_accruals results
    on results.user_id = user.id
      and results.period_id = current_period_id
  where
    cmb.period_id = current_period_id
    and cmb.points <> 0
    and user.id not in (1, 2);

end;

