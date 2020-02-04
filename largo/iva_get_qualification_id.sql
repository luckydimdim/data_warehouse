create
    definer = iva@`%` function iva_get_qualification_id(turnover decimal(9, 2)) returns int
begin
  if turnover < 100 then
    return 0;
  end if;

  return (
    select
      id
    from
      iva_qualifications
    where
      lower_bound <= turnover
      and upper_bound > turnover);
  end;

