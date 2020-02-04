create
    definer = iva@`%` procedure iva_update_cmb_order_status(in current_order_id               int,
                                                            in current_period_id              int,
                                                            in current_order_status           varchar(255),
                                                            in current_partial_payment_status varchar(255))
begin

  if current_period_id is null then
    set current_period_id = iva_get_period_id(null);
  end if;

    if current_order_status is null then
      set current_order_status = 'completed';
    end if;

    if current_partial_payment_status is null then
      set current_partial_payment_status = 'no';
    end if;

    update
      iva.b_iblock_element_prop_s87
    set
      property_2196 = upper(current_order_status),
      property_2195 = upper(current_partial_payment_status)
    where
      iblock_element_id = current_order_id;

    update
      iva_cmb_transactions
    set
      status = current_order_status
    where
      order_id = current_order_id;

    update
      iva_cmb_orders
    set
      status = current_order_status,
      partial_payment_status = current_partial_payment_status
    where
      period_id = current_period_id
      and order_id = current_order_id;


    call largo.iva_update_cmb_order_status(current_order_id);
  end;

