create
    definer = iva@`%` procedure iva_create_mp_accruals(in current_order_id  int,
                                                       in current_period_id int)
begin

    declare current_user_id int;
    declare is_new_order int;

    if current_period_id is null then
      set current_period_id = iva_get_period_id(null);
    end if;

    calculations:begin

    select
      order_id,
      user_id
    into
      is_new_order,
      current_user_id
    from
      iva_mp_orders
    where
      period_id = current_period_id
      and status = 'new'
      and order_id = current_order_id
      and accruals_status = 'n';

      if is_new_order is null then
        leave calculations;
      end if;

      if current_period_id is null then
        set current_period_id = iva_get_period_id(null);
      end if;

      general_bonus:begin

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

      end;

      temporary_bonuses:begin


        call iva_create_mp_bs_accruals(current_period_id);


        call iva_create_mp_sb_accruals(current_period_id);

      end;

      results:begin


        call iva_create_mp_total_accruals(current_period_id);


        call iva_update_mp_order_status(current_order_id, current_period_id, 'completed', 'y');

      end;

      finalize:begin


        call iva_update_mp_period_activations(current_period_id);


        call iva_create_mp_order_accruals(current_order_id, current_period_id);

      end;

      other:begin


        call largo.iva_create_mp_order(current_order_id);
        call largo.iva_create_mp_order_user_package(current_order_id);
        call largo.iva_update_mp_order_status(current_order_id);
        call largo.iva_update_user(current_user_id);
        call largo.iva_update_user_activation(current_user_id, current_period_id);
        call largo.iva_create_mp_user_root(current_order_id, current_period_id);
        call largo.iva_create_mp_order_accruals(current_order_id, current_period_id);
        call largo.iva_update_mp_order_profits(current_order_id, current_period_id);
        call largo.iva_update_user_totals(current_period_id);
        call largo.iva_update_mp_period_branches(current_period_id);

      end;

    end;
  end;

