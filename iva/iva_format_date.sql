create
    definer = iva@`%` function iva_format_date(datetime datetime,
                                               short    tinyint(1)) returns varchar(255)
begin
  if datetime is null then
    return null;
  end if;

  set @format = '%d.%m.%Y %k:%i:%s';

  if short = true then
    set @format = '%d.%m.%Y';
  end if;

  return date_format(datetime, @format);
end;

