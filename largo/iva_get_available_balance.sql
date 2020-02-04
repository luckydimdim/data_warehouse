create
    definer = iva@`%` function iva_get_available_balance(current_user_id int) returns decimal(9, 2)
begin
  declare available_balance decimal(9, 2) default 0.00;

  set available_balance = (
    select
      mp.amount - withdrawal.amount available_balance
    from
      iva_users users

      left join (
        select
          ifnull(sum(amount), 0) amount,
          current_user_id user_id
        from
          iva_withdrawals
        where
          user_id = current_user_id
          and status = 'complete') withdrawal
      on withdrawal.user_id = users.id

      join (
        select
          ifnull(sum( if (results.activation = true, results.mp_money, 0) + (if (results.period_id >= 4, results.cmb_money, 0)) + results.extra_money), 0) amount,
          current_user_id user_id
        from
          iva_profits results

          join iva_periods periods
          on results.period_id = periods.id
            and now() > ifnull(withdrawal_start, periods.finish)
        where
          results.user_id = current_user_id) mp
      on mp.user_id = users.id
  );

  if available_balance is null then
    set available_balance = 0.00;
  end if;

  return available_balance;
end;

