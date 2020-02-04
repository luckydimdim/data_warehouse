create
    definer = iva@`%` procedure iva_loop()
begin

  declare done int default false;
  declare current_order_id int;
  declare current_period_id int;

  declare cursor1 cursor for
    select distinct order_id, period_id from libra.iva_mp_order_accruals order by created;

  declare continue handler for not found set done = true;

  open cursor1;

  read_loop: loop
    fetch cursor1 into current_order_id, current_period_id;

    if done then
      leave read_loop;
    end if;





    call largo.iva_create_mp_order_accruals(current_order_id, current_period_id);
  end loop;

end;

