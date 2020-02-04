create
    definer = iva@`%` procedure iva_create_mp_period_accruals(in current_period_id int)
begin

  declare done int default false;
  declare current_order_id int;

  declare cursor1 cursor for
    select
      order_props.iblock_element_id order_id
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
    fetch cursor1 into current_order_id;

    if done then
      leave read_loop;
    end if;

    call iva_create_mp_order(current_order_id);
    call iva_create_mp_accruals(current_order_id, current_period_id);
  end loop;

end;

