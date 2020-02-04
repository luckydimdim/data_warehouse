create
    definer = iva@`%` procedure iva_read_balance_report()
begin

  with mp_amount (user_id, value) as (
    select
      user_id,
      sum(money)
    from
      iva_mp_accruals
    where
      activation = true
      and period_id < iva_get_period_id(null)
    group by
      user_id),

    cmb_amount (user_id, value) as (
      select
        user_id,
        sum(money)
      from
        iva_cmb_accruals
      where
        period_id < iva_get_period_id(null) and period_id > 3
      group by
        user_id),

    withdrawal_amount (user_id, value, count) as (
      select
        user_id,
        ifnull(sum(amount), 0),
        count(user_id) count_withdrawals
      from
        iva_withdrawals
      where
        status = 'complete'
      group by
        user_id)

  select
    users.id user_id,
    concat_ws(' ', users.name, users.surname) user_name_and_surname,
    users.login,
    users.phone,
    ifnull(mp_amount.value, 0) mp_amount,
    ifnull(cmb_amount.value, 0) cmb_amount,
    ifnull(withdrawal_amount.value, 0) withdrawal_amount,
    ifnull(withdrawal_amount.count, 0) withdrawals_count,
    ifnull(mp_amount.value, 0) + ifnull(cmb_amount.value, 0) - ifnull(withdrawal_amount.value, 0) available_amount
  from
    largo.iva_users users

    left join mp_amount
    on mp_amount.user_id = users.id

    left join cmb_amount
    on cmb_amount.user_id = users.id

    left join withdrawal_amount
    on withdrawal_amount.user_id = users.id
  where
    users.id not in (1, 2)
    and (mp_amount.value > 0
      or cmb_amount.value > 0)
  order by
    available_amount desc;

end;

