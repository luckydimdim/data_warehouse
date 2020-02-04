create
    definer = iva@`%` function iva_get_qualification_name_by_percent(current_percent decimal(9, 2)) returns varchar(255)
begin

  if current_percent < 0 then
    return 'Нет';
  end if;

  return (
    select
      name
    from
      iva_qualifications
    where
      percent = current_percent);
  end;

