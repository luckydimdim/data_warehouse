create
    definer = iva@`%` function iva_get_period_id(datetime datetime) returns int
begin
  if datetime is null then
    return (
      select
        max(id)
      from
        iva_periods
      where
        start <= now() and now() <= finish);
  else
    return (
      select
        max(id)
      from
        iva_periods
      where
        datetime >= start and datetime <= finish);
  end if;

end;

