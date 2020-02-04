create
    definer = iva@`%` function iva_get_period_name_by_id(period_id int) returns varchar(255)
begin
  if period_id is null then
    set period_id = iva_get_period_id(null);
  end if;

    return (
      select
        name
      from
        iva_periods
      where
        id = period_id);
end;

