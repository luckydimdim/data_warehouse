create
    definer = iva@`%` function iva_get_user_discount(current_user_id int) returns decimal(9, 2)
begin
  declare lead_discount decimal(9, 2);
  declare personal_discount decimal(9, 2);
  declare current_user_package_name varchar(255);

  select
    ifnull(greatest(kp, cmb), 0) lead_discount,
    ifnull(if (has_business, 'Business', package_name), 'Silver')
  into
    lead_discount,
    current_user_package_name
  from
    iva_users
  where
    id = current_user_id;

  select
    value
  into
    personal_discount
  from
    iva_package_discounts
  where
    package_name = current_user_package_name;

  return
    (select ( 1 - (1 - personal_discount / 100) * (1 - lead_discount / 100) ) * 100 summary_discount);
end;

