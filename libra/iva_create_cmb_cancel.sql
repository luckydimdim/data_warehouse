create
    definer = iva@`%` procedure iva_create_cmb_cancel(in current_order_id  int,
                                                      in current_period_id int,
                                                      in current_comment   varchar(255))
proc:begin

  if current_period_id is null then
    set current_period_id = iva_get_period_id(null);
  end if;

  set @is_order_in_current_period = (
    select
      if (property_2198 = current_period_id, true, false) periods_are_equal
    from
      iva.b_iblock_element_prop_s87
    where
      iblock_element_id = current_order_id);

  if @is_order_in_current_period = false then
    leave proc;
  end if;

  update
    iva.b_iblock_element_prop_s87
  set
    property_2196 = 'CANCELED'
  where
    iblock_element_id = current_order_id;

  update
    iva_cmb_orders
  set
    status = 'canceled'
  where
    order_id = current_order_id;

  call iva_create_cmb_transactions_cancel(current_order_id, current_period_id, current_comment);
  call iva_update_cmb_order_accruals(current_order_id, current_period_id);


  call largo.iva_update_cmb_order(current_order_id);
  call largo.iva_update_cmb_order_accruals(current_order_id, current_period_id);
  call largo.iva_update_cmb_order_profits(current_order_id, current_period_id);
  call largo.iva_update_user_totals(current_period_id);
  call largo.iva_update_cmb_user_branches(current_period_id);
end;

