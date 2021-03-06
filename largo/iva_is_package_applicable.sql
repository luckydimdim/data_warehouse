create
    definer = iva@`%` function iva_is_package_applicable(current_user_id                 int,
                                                         current_package_id              int,
                                                         subscription_duration_in_months int,
                                                         package_price                   decimal(12, 4)) returns tinyint(1)
begin
  return (
    select
      package_id < current_package_id
      or (package_id = current_package_id
        and package_price = 0
        and subscription_duration_in_months > 0)
    from
      iva_users
    where
      id = current_user_id);
end;

