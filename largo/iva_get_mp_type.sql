create
    definer = iva@`%` function iva_get_mp_type(period_id int) returns int
begin

    if period_id is null then
      set period_id = iva_get_period_id(null);
    end if;

    return (
      select
        mp_type
      from
        iva_periods
      where
        id = period_id);

end;

