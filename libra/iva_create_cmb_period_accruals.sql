create
    definer = iva@`%` procedure iva_create_cmb_period_accruals(in current_period_id int)
begin

  declare done int default false;
  declare current_order_id int;

  declare cursor1 cursor for
    select
      order_props.order_id
    from
      iva_cmb_orders order_props
    where
      order_props.period_id = current_period_id
      and order_props.status in ('new', 'completed')
    order by
      order_props.created asc;

  declare continue handler for not found set done = true;



  call iva_create_cmb_period_orders(current_period_id);

  open cursor1;

  read_loop: loop
    fetch cursor1 into current_order_id;

    if done then
      leave read_loop;
    end if;

    call iva_create_cmb_order_transactions(current_order_id, current_period_id);
    call iva_create_cmb_extra_transactions(current_order_id, current_period_id);

    call iva_update_cmb_order_accruals(current_order_id, current_period_id);


    call largo.iva_create_cmb_order_accruals(current_order_id, current_period_id);
    call largo.iva_update_cmb_order_profits(current_order_id, current_period_id);

    if done then
      set done = false;
    end if;
  end loop;

  call largo.iva_update_user_totals(current_period_id);
  call largo.iva_update_cmb_user_branches(current_period_id);
end;

