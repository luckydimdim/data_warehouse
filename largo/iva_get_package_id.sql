create
    definer = iva@`%` function iva_get_package_id(package_name varchar(255)) returns int
begin

  return (
    select
      id
    from
      iva_packages
    where
      name = package_name
      or alias = package_name);

end;

