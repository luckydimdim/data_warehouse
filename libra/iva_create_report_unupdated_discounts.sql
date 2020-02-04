create
    definer = iva@`%` procedure iva_create_report_unupdated_discounts()
begin
  with users_to_check (id, email, discount) as (
    select
      lgu.id,
      lgu.email,
      lbu.external_discount discount
    from
      largo.iva_users lgu

      join libra.iva_users lbu
      on lbu.user_id = lgu.id
    where
      lgu.is_package_expired = false
      and lgu.package_name <> 'Silver'
    union
    select
      lbu.user_id,
      lbu.email,
      lbu.external_discount discount
    from
      libra.iva_users lbu
    where
      lbu.external_discount <> 0)

  select
    users_to_check.id,
    users_to_check.email,
    users_to_check.discount,
    iva_get_user_discount(users_to_check.id) percent
  from
    users_to_check
  group by
    users_to_check.id
  having
    users_to_check.discount <> percent;
end;

