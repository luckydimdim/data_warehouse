create
    definer = iva@`%` procedure iva_create_mp_sb_accruals(in current_period_id int)
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
            history.user_id,
            history.new_package_id
          having
            date_add(min(history.created), interval +30 day) between iva_get_period_start(current_period_id) and iva_get_period_finish(current_period_id)
            and count(history.new_package_id) = 1)

        select
          users.user_id,
          iva_get_sponsor_bonus(
            sum( if (history.new_package_name = 'Gold', 1, 0) ),
            sum( if (history.new_package_name = 'Platinum', 1, 0) )
          ) value
        from
          users

          join largo.iva_user_roots tree
          on tree.parent_id = users.user_id
            and tree.is_leaf = true

          join largo.iva_user_packages history
          on history.user_id = tree.child_id
            and history.created between users.upgrade_date and date_add(users.upgrade_date, interval +30 day)
        group by
          users.user_id) sb
      on sb.user_id = results.user_id
    set
      results.sb = sb.value
    where
      results.period_id = current_period_id;

  end;

