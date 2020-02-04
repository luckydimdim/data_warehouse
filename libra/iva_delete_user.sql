create
    definer = iva@`%` procedure iva_delete_user(in user_id_or_email varchar(255))
begin

  declare current_user_id int;
  declare current_parent_id int;

  if iva_is_numeric(user_id_or_email) = false then
    set current_user_id = iva_get_user_id(user_id_or_email);
  else
    set current_user_id = cast (user_id_or_email as int);
  end if;

  set current_parent_id = (
    select
      parent_id
    from
      largo.iva_users
    where
      id = current_user_id);

  call iva_delete_user_orders(current_user_id);
  call iva_delete_user_operations(current_user_id);
  call iva_delete_user_roots(current_user_id);
  call iva_delete_user_branches(current_user_id);
  call iva_delete_user_withdrawals(current_user_id);


  call largo.iva_delete_user(current_user_id);
  call largo.iva_delete_user_transfers(current_user_id);
  call largo.iva_delete_mp_user_orders(current_user_id);
  call largo.iva_delete_cmb_user_orders(current_user_id);
  call largo.iva_delete_user_roots(current_user_id);
  call largo.iva_update_user_root(current_parent_id);
  call largo.iva_delete_user_branch(current_user_id);
  call largo.iva_delete_user_branches(current_user_id);
  call largo.iva_update_period_profits(null);
  call largo.iva_update_user_totals(null);
end;

