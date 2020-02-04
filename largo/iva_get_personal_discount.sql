create
    definer = iva@`%` function iva_get_personal_discount(current_package_id varchar(255)) returns decimal(9, 2)
begin
  return (
    select
      value
    from
      iva_package_discounts
    where
      package_id = current_package_id);
end;

