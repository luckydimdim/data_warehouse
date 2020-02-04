create
    definer = iva@`%` procedure iva_create_mp_bs_accruals(in current_period_id int)
begin


    update
      iva_mp_accruals results

      join (
        with users (user_id, upgrade_date) as (
          select
            history.user_id,
            min(history.created) min_date
          from
            largo.iva_user_packages history
          where
            history.new_package_name in ('Gold', 'Platinum')
          group by
            history.user_id
          having
            date_format(date_add(min(history.created), interval +3 month), '%Y-%m' ) >= date_format(iva_get_period_finish(current_period_id), '%Y-%m'))

        select
          users.user_id,
          results.lb * 0.7 value
        from
          users

          join iva_mp_accruals results
          on results.user_id = users.user_id
            and results.period_id = current_period_id) bs
      on bs.user_id = results.user_id
    set
      results.bs = bs.value
    where
      results.period_id = current_period_id;

end;

