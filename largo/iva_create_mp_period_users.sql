create
    definer = iva@`%` procedure iva_create_mp_period_users(in current_period_id int)
begin
    if current_period_id is null then
      set current_period_id = iva_get_period_id(null);
    end if;

    insert iva_users (
      login,
      password,
      name,
      surname,
      email,
      email_extra,
      source,
      birthdate,
      phone,
      phone_extra,
      city,
      parent_id,
      package_id,
      package_name,
      package_expires,
      is_package_expired,
      id,
      is_password_expired,
      sequre_token,
      sequre_token_expires,
      show_all_teams,
      permanent_activation,
      permanent_activation_till,
      email_confirmed)
    with period_users (user_id) as (
      select distinct
        user_id
      from
        libra.iva_mp_orders
      where
        period_id = current_period_id)
    select
      users.login,
      users.password,
      users.name,
      users.last_name,
      users.email,
      user_props.uf_email,
      ifnull(users.lid, ''),
      users.personal_birthdate,
      users.personal_phone,
      user_props.uf_phone,
      users.personal_city,
      user_props.uf_invate,
      user_props.uf_package_new,
      iva_get_package_name(user_props.uf_package_new),
      user_props.uf_active_date,
      if (user_props.uf_active_date is not null and user_props.uf_active_date > now(), false, true),
      users.id,
      user_props.uf_need_create_pass,
      user_props.uf_auth_token,
      user_props.uf_auth_token_date,
      user_props.uf_show_all_teams,
      user_props.uf_has_activation,
      user_props.uf_activation_till,
      users.email_confirmed
    from
      period_users

      join iva.b_user users
      on users.id = period_users.user_id

      join iva.b_uts_user user_props
      on user_props.value_id = users.id
    where
      users.active = 'Y'

  on duplicate key update
      largo.iva_users.login = users.login,
      largo.iva_users.password = users.password,
      largo.iva_users.name = users.name,
      largo.iva_users.surname = users.last_name,
      largo.iva_users.email = users.email,
      largo.iva_users.email_extra = user_props.uf_email,
      largo.iva_users.source = ifnull(users.lid, ''),
      largo.iva_users.birthdate = users.personal_birthdate,
      largo.iva_users.phone = users.personal_phone,
      largo.iva_users.phone_extra = user_props.uf_phone,
      largo.iva_users.city = users.personal_city,
      largo.iva_users.parent_id = user_props.uf_invate,
      largo.iva_users.package_id = user_props.uf_package_new,
      largo.iva_users.package_name = iva_get_package_name(user_props.uf_package_new),
      largo.iva_users.package_expires = user_props.uf_active_date,
      largo.iva_users.is_package_expired = if (user_props.uf_active_date is not null and user_props.uf_active_date > now(), false, true),
      largo.iva_users.is_password_expired = user_props.uf_need_create_pass,
      largo.iva_users.sequre_token = user_props.uf_auth_token,
      largo.iva_users.sequre_token_expires = user_props.uf_auth_token_date,
      largo.iva_users.show_all_teams = user_props.uf_show_all_teams,
      largo.iva_users.permanent_activation = user_props.uf_has_activation,
      largo.iva_users.permanent_activation_till = user_props.uf_activation_till,
      largo.iva_users.email_confirmed = users.email_confirmed,
      largo.iva_users.available_amount = iva_get_available_balance(users.id);

  call largo.iva_create_mp_period_user_requisites(current_period_id);
end;

