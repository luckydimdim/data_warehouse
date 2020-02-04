create
    definer = iva@`%` function iva_get_withdrawal_start(period_id int) returns datetime
begin
  if period_id is null then
    return (select
        ifnull(withdrawal_start, finish)
      from
        iva_periods
      where
        start < now()
        and finish > now()
        and id <> 0);
  else
    return (select
        ifnull(withdrawal_start, finish)
      from
        iva_periods
      where
        id = period_id);
  end if;

  end;

