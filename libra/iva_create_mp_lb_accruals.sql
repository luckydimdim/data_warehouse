create
    definer = iva@`%` procedure iva_create_mp_lb_accruals(in current_order_id  int,
                                                          in current_period_id int)
begin

  update
    iva_mp_accruals results

    join (
      select
        roots.parent_id,
        roots.points,

        iva_get_linear_percent(
          if (roots.child_package_name = 'Silver', roots.depth, roots.depth + 1),
          ifnull(results.k, 0)) / 100 percent,
        sum(roots.points * iva_get_linear_percent(
          if (roots.child_package_name = 'Silver', roots.depth, roots.depth + 1),
          ifnull(results.k, 0)) / 100) value
      from
        iva_mp_user_branches roots

        left join iva_mp_accruals results
        on results.period_id = current_period_id
          and results.user_id = roots.parent_id
      where
        roots.period_id = current_period_id
        and roots.order_id = current_order_id
        and roots.is_new = true

        and (roots.child_package_name <> 'Silver'
          or roots.child_id <> roots.parent_id)
      group by
        roots.parent_id) lb
    on lb.parent_id = results.user_id
  set
    results.lb = lb.value
  where
    results.period_id = current_period_id;

  end;

