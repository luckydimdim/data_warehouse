create
    definer = iva@`%` procedure iva_update_cmb_order_accruals(in current_order_id  int,
                                                              in current_period_id int)
begin
  if current_period_id is null then
    set current_period_id = iva_get_period_id(null);
  end if;

  delete
    accruals
  from
    iva_cmb_accruals accruals

    join iva_cmb_transactions transactions
    on transactions.period_id = current_period_id
      and transactions.target_user_id = accruals.user_id
      and transactions.order_id = current_order_id
  where
    accruals.period_id = current_period_id;

  insert iva_cmb_accruals
    (user_id, created, period_id, points, money)
  select
    transactions.target_user_id,
    iva_get_period_finish(transactions.period_id),
    current_period_id,
    sum(transactions.points),
    sum(transactions.price)
  from
    iva_cmb_transactions order_users

    join iva_cmb_transactions transactions
    on transactions.period_id = current_period_id
      and transactions.target_user_id = order_users.target_user_id
  where
    order_users.period_id = current_period_id
    and order_users.order_id = current_order_id
  group by
    transactions.target_user_id;

  update
    iva_cmb_accruals accruals

    join iva_extra_profits profits
    on profits.period_id = accruals.period_id
      and profits.user_id = accruals.user_id
      and profits.cmb_points > 0
  set
    accruals.points = (accruals.points + profits.cmb_points),
    accruals.money = (accruals.points + profits.cmb_points) * 60;

end;

