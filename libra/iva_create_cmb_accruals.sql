create
    definer = iva@`%` procedure iva_create_cmb_accruals(in current_order_id  int,
                                                        in current_period_id int)
begin

  if current_period_id is null then
    set current_period_id = iva_get_period_id(null);
  end if;

  call iva_create_cmb_order_transactions(current_order_id, current_period_id);
  call iva_create_cmb_extra_transactions(current_order_id, current_period_id);

  call iva_update_cmb_order_accruals(current_order_id, current_period_id);


  call largo.iva_create_cmb_order_accruals(current_order_id, current_period_id);
  call largo.iva_update_cmb_order_profits(current_order_id, current_period_id);
  call largo.iva_update_user_totals(current_period_id);
  call largo.iva_update_cmb_user_branches(current_period_id);

  set @is_order_canceled = (
    select
      order_id
    from
      iva_cmb_orders
    where
      order_id = current_order_id
      and status = 'canceled');

    if @is_order_canceled is not null then
      call iva_create_cmb_cancel(current_order_id, current_period_id, 'Отменен');
    end if;
end;

