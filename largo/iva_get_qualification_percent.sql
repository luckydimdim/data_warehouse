create
    definer = iva@`%` function iva_get_qualification_percent(amount decimal(9, 2)) returns decimal(9, 2)
begin

  if amount < 100 then
    return 0;
  end if;

  return (select
        percent
      from
        iva_qualifications
      where
        lower_bound <= amount
        and upper_bound > amount);
  end;

