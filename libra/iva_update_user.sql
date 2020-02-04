create
    definer = iva@`%` procedure iva_update_user(in current_user_id int)
begin

  update
    iva_users

    join iva.b_uts_user user_props
    on user_props.value_id = iva_users.user_id

    join iva.b_user users
    on users.id = user_props.uf_invate
  set
    iva_users.partner_id = users.id,
    iva_users.partner_email = users.login
  where
    iva_users.user_id = current_user_id;


  call largo.iva_update_user(current_user_id);
  call largo.iva_update_user_root(current_user_id);
  call largo.iva_update_user_branch(current_user_id, null);
  call largo.iva_update_user_branches(current_user_id, null);
  call largo.iva_update_user_accruals(current_user_id);
  call largo.iva_update_mp_user_roots(current_user_id);
  call largo.iva_update_user_profit(current_user_id, null);
  call largo.iva_update_user_totals(null);

  call largo.iva_create_user_branch(current_user_id);
end;

