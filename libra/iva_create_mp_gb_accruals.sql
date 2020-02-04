create
    definer = iva@`%` procedure iva_create_mp_gb_accruals(in current_order_id  int,
                                                          in current_period_id int)
begin

    update
      iva_mp_accruals results

      join (
        select
          branches.parent_id user_id,
          branches.parent_go,
          branches.parent_kp,
          branches.child_id,
          branches.child_go,
          branches.child_kp,
          branches.parent_go * branches.parent_kp / 100 - sum(branches.child_go * branches.child_kp / 100) value
        from
          iva_mp_user_branches branches


        where
          branches.order_id = current_order_id
          and branches.is_first_line = true
          and branches.parent_kp > branches.child_kp
        group by
          branches.parent_id) gb
      on gb.user_id = results.user_id
    set
      results.gb = gb.value
    where
      results.period_id = current_period_id;

  end;

