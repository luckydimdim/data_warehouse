create
    definer = iva@`%` function iva_get_package_name(package_id int) returns varchar(255)
begin
  return (select
      name
    from
      iva_packages
    where
      id = package_id);
  end;

