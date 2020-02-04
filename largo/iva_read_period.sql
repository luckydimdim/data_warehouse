create
    definer = iva@`%` procedure iva_read_period(in period_id int)
begin
  if period_id is null then
    select
      *
    from
      iva_periods
    where
      is_closed = false
      and start <= now() and now() < finish;
  else
    select
      *
    from
      iva_periods
    where
      id = period_id;
  end if;
end;

