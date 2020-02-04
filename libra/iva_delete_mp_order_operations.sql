create
    definer = iva@`%` procedure iva_delete_mp_order_operations(in current_order_id  int,
                                                               in current_period_id int)
begin

    if current_period_id is null then
      set current_period_id = iva_get_period_id(null);
    end if;

    call iva_delete_mp_order_accruals(current_order_id, current_period_id);
    call iva_delete_mp_order_user_roots(current_order_id, current_period_id);
    call iva_delete_mp_order_user_branches(current_order_id, current_period_id);
    call iva_delete_mp_order_transactions(current_order_id, current_period_id);
    call iva_delete_mp_order_user_package(current_order_id);


    call largo.iva_delete_mp_order_root(current_order_id, current_period_id);
    call largo.iva_delete_mp_order_accruals(current_order_id, current_period_id);
    call largo.iva_create_mp_order_profits_cancel(current_order_id, current_period_id);
    call largo.iva_update_mp_order_profits(current_order_id, current_period_id);
    call largo.iva_update_user_totals(current_period_id);
    call largo.iva_update_mp_period_branches(current_period_id);

end;

