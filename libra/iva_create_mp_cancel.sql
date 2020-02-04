create
    definer = iva@`%` procedure iva_create_mp_cancel(in current_order_id  int,
                                                     in current_period_id int,
                                                     in current_comment   varchar(255))
proc:begin

  if current_period_id is null then
    set current_period_id = iva_get_period_id(null);
  end if;

  set @is_order_in_current_period = (
    select
      if (property_2199 = current_period_id, true, false) periods_are_equal
    from
      iva.b_iblock_element_prop_s74
    where
      iblock_element_id = current_order_id);

  if @is_order_in_current_period = false then
    leave proc;
  end if;

  call iva_update_mp_order_status(current_order_id, current_period_id, 'canceled', 'y');

  call iva_delete_mp_period_operations(current_period_id);
  call iva_create_mp_period_accruals(current_period_id);
end;

