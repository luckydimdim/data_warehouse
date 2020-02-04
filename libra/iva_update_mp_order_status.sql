create
    definer = iva@`%` procedure iva_update_mp_order_status(in current_order_id       int,
                                                           in current_period_id      int,
                                                           in current_order_status   varchar(255),
                                                           in current_accrual_status varchar(255))
begin

  if current_period_id is null then
    set current_period_id = iva_get_period_id(null);
  end if;

    if current_order_status is null then
      set current_order_status = 'completed';
    end if;

    if current_accrual_status is null then
      set current_accrual_status = 'y';
    end if;

    update
      iva.b_iblock_element_prop_s74
    set
      property_2190 = upper(current_accrual_status),
      property_2201 = upper(current_order_status)
    where
      iblock_element_id = current_order_id;

    update
      iva_mp_transactions
    set
      status = current_order_status
    where
      order_id = current_order_id;

    update
      iva_mp_orders
    set
      status = current_order_status,
      accruals_status = current_accrual_status
    where
      period_id = current_period_id
      and order_id = current_order_id;

  end;

