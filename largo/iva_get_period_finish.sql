create
    definer = iva@`%` function iva_get_period_finish(period_id int) returns datetime
begin
  if period_id is null then
    return (
      select
        finish
      from
        iva_periods
      where
        is_closed = false
        and start <= now() and now() < finish);
  else
    return (
      select
        finish
      from
        iva_periods
      where
        id = period_id);
  end if;
  end;

