create
    definer = iva@`%` procedure iva_create_mp_ko_accruals(in current_order_id  int,
                                                          in current_period_id int)
begin

  update
    iva_mp_accruals results

    join iva_mp_transactions bonus
    on bonus.period_id = current_period_id
      and bonus.order_id = current_order_id
      and bonus.target_user_id = results.user_id
  set
    results.ko = results.o1l * 2.5 + results.bo * 1.5
  where
    results.period_id = current_period_id;

end;

