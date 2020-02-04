create
    definer = iva@`%` function iva_is_package_applicable(current_user_id                 int,
                                                         current_package_id              int,
                                                         subscription_duration_in_months int,
                                                         package_price                   decimal(12, 4)) returns tinyint(1)
begin
  return largo.iva_is_package_applicable(current_user_id, current_package_id, subscription_duration_in_months, package_price);
end;

