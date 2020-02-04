create
    definer = iva@`%` procedure iva_delete_mp_period_user_packages(in current_period_id int)
begin

  if current_period_id is null then
    set current_period_id = iva_get_period_id(null);
  end if;

  update
    iva.b_uts_user users

    join (
      select
        user_id,
        min(old_package_id) package_id,
        min(old_package_expires) package_expires
      from
        largo.iva_user_packages packages
      where
        packages.period_id = current_period_id
      group by
        user_id) packages
    on packages.user_id = users.value_id
  set
    users.uf_package_new = packages.package_id,
    users.uf_active_date = packages.package_expires;

  update
    iva_users users

    join (
      select
        user_id,
        min(old_package_id) package_id,
        min(old_package_expires) package_expires
      from
        largo.iva_user_packages packages
      where
        packages.period_id = current_period_id
      group by
        user_id) packages
    on packages.user_id = users.user_id
  set
    users.package_id = packages.package_id,
    users.package_name = iva_get_package_name(packages.package_id),
    users.package_expires = packages.package_expires;

end;

