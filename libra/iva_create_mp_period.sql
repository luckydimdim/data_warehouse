create
    definer = iva@`%` procedure iva_create_mp_period(in current_period_id int)
begin

  declare done int default false;
  declare current_order_id int;
  declare current_user_id int;

  declare cursor1 cursor for
    select
      order_props.iblock_element_id order_id,
      order_props.property_2015 user_id
    from
      iva.b_iblock_element_prop_s74 order_props
    where
      order_props.property_2199 = current_period_id
      and order_props.property_2201 = 'COMPLETED'
    order by
      order_props.property_2200 asc;

  declare continue handler for not found set done = true;


  call iva_create_new_period(current_period_id);

  open cursor1;

  read_loop: loop
    fetch cursor1 into current_order_id, current_user_id;

    if done then
      leave read_loop;
    end if;

    call iva_create_mp_order(current_order_id);


    call iva_create_mp_order_user_package(current_order_id);


    call iva_update_mp_period_orders_sequences(current_period_id);


    call iva_create_mp_user_root(current_order_id, current_period_id);


    call iva_create_mp_order_transactions(current_order_id, current_period_id);


    call iva_update_mp_period_transactions_sequences(current_period_id);


    call iva_create_mp_order_accrual_init(current_order_id, current_period_id);


    call iva_create_mp_osv_accruals(current_order_id, current_period_id);


    call iva_create_mp_bo_accruals(current_order_id, current_period_id);


    call iva_create_mp_kp_accruals(current_order_id, current_period_id);


    call iva_create_mp_user_branch(current_order_id, current_period_id);


    call iva_create_mp_lb_accruals(current_order_id, current_period_id);


    call iva_create_mp_gb_accruals(current_order_id, current_period_id);


    call iva_create_mp_bs_accruals(current_period_id);


    call iva_create_mp_sb_accruals(current_period_id);


    call iva_create_mp_total_accruals(current_period_id);


    call iva_update_mp_order_status(current_order_id, current_period_id, 'completed', 'y');


    call iva_update_mp_period_activations(current_period_id);


    call iva_create_mp_order_accruals(current_order_id, current_period_id);

    set done = false;

  end loop;

end;

