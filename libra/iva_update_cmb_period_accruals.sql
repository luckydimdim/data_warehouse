create
    definer = iva@`%` procedure iva_update_cmb_period_accruals(in current_period_id int)
begin

  if current_period_id is null then
    set current_period_id = iva_get_period_id(null);
  end if;

  delete from
    iva_cmb_accruals
  where
    period_id = current_period_id;

  insert iva_cmb_accruals
    (user_id, created, period_id, points, money)
  select
    target_user_id,
    iva_get_period_finish(period_id),
    current_period_id,
    sum(points),
    sum(price)
  from
    iva_cmb_transactions
  where
    period_id = current_period_id
  group by
    target_user_id;

end;

