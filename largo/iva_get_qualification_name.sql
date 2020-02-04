create
    definer = iva@`%` function iva_get_qualification_name(qualification_id int) returns varchar(255)
begin
  if qualification_id is null then
    return 'Нет';
  end if;

  return (select
      name
    from
      iva_qualifications
    where
      id = qualification_id);
  end;

