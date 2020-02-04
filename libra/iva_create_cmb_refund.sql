create
    definer = iva@`%` procedure iva_create_cmb_refund(in current_order_id  int,
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

  if @is_order_in_current_period = true then
    leave proc;
  end if;

  insert iva_cmb_transactions
    (order_id, source_user_id, source_package_name, target_user_id,
     target_package_name, created, price, points, comment, period_id, modified, status)
  select
    order_id, source_user_id, source_package_name, target_user_id,
    target_package_name, now(), price * -1, points * -1, current_comment, current_period_id, now(), 'refund'
  from
    iva_cmb_transactions
  where
    order_id = current_order_id;

  call iva_update_cmb_order_accruals(current_order_id, current_period_id);


  call largo.iva_update_cmb_order_accruals(current_order_id, current_period_id);
  call largo.iva_update_cmb_order_profits(current_order_id, current_period_id);
  call largo.iva_update_user_totals(current_period_id);
  call largo.iva_update_cmb_user_branches(current_period_id);
end;

