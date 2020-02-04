create
    definer = iva@`%` procedure iva_delete_cmb_order_accruals(in current_order_id  int,
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
      and transactions.order_id = current_order_id
      and transactions.target_user_id = accruals.user_id
  where
    accruals.period_id = current_period_id;
end;

