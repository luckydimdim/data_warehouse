create
    definer = iva@`%` procedure iva_create_user_permantnt_activation(in current_user_id            int,
                                                                     in current_duration_in_months int)
begin
  declare current_period_id int;
  set current_period_id = iva_get_period_id(null);

  update
    iva.b_uts_user
  set
    uf_has_activation = true,
    uf_activation_till = concat(last_day(date_add(now(), interval +current_duration_in_months-1 month)), ' 23:59:59')
  where
    value_id = current_user_id;



  call largo.iva_update_user(current_user_id);


  insert iva_mp_accruals
    (created, period_id, user_id, package_name, activation)
  select
    iva_get_period_finish(current_period_id),
    current_period_id,
    user_props.id,
    user_props.package_name,
    true
  from
    largo.iva_users user_props

    left join iva_mp_accruals results
    on results.period_id = current_period_id
      and results.user_id = user_props.id
  where
    user_props.permanent_activation = true
    and ( user_props.permanent_activation_till is null
      or user_props.permanent_activation_till >= iva_get_period_finish(current_period_id) )
    and results.id is null;
end;

