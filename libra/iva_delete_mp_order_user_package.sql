create
    definer = iva@`%` procedure iva_delete_mp_order_user_package(in current_order_id int)
begin

  declare current_user_id int;

  set current_user_id = (
    select
      user_id
    from
      largo.iva_user_packages
    where
      order_id = current_order_id);

  begin
    update
      iva.b_uts_user users

      join largo.iva_user_packages packages
      on packages.user_id = users.value_id
        and packages.order_id = current_order_id
    set
      users.uf_package_new = packages.old_package_id,
      users.uf_active_date = packages.old_package_expires;
  end;


  begin
    call largo.iva_update_user(current_user_id);
    call largo.iva_delete_mp_order_user_package(current_order_id);
  end;

end;

