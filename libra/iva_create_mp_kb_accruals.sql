create
    definer = iva@`%` procedure iva_create_mp_kb_accruals(in current_order_id  int,
                                                          in current_period_id int)
begin

    update
      iva_mp_accruals results

      join (
        with kb (parent_id, child_id, generation, percent, go, kb) as (

          with users (user_id, depth) as (
            select
              users.target_user_id,
              tree.depth
            from
              iva_mp_transactions users

              join iva_mp_user_roots tree
              on tree.order_id = current_order_id
                and tree.parent_id = users.target_user_id
            where
              users.period_id = current_period_id
              and users.order_id = current_order_id
            group by
              users.target_user_id),

          percents (parent_id, child_id, child_depth, user_depth, generation, value) as (
            select
              users.user_id,
              child.child_id,
              child.depth + 1 child_depth,
              users.depth user_depth,
              child.depth - users.depth + 1 generation,
              iva_get_team_percent( child.depth - users.depth + 1, ifnull(results.k, 0) ) percent
            from
              users

              join iva_mp_user_roots parent
              on parent.order_id = current_order_id
                and parent.parent_id = users.user_id

              join iva_mp_user_roots child
              on child.order_id = current_order_id
                and child.child_id = parent.child_id
                and child.depth - parent.depth <= 7
                and child.is_leaf = true

              join iva_mp_accruals results
              on results.period_id = current_period_id
                and results.user_id = users.user_id
            where
              parent.period_id = current_period_id
            group by
              users.user_id,
              child.child_id)

          select
            percents.parent_id,
            percents.child_id,
            percents.generation,
            percents.value,
            sum(bonus.go_subscribe),
            sum(bonus.go_subscribe) * percents.value / 100 kb
          from
            percents

            join iva_mp_transactions bonus
            on bonus.period_id = current_period_id
              and bonus.source_user_id = percents.child_id
              and bonus.target_user_id = percents.parent_id
          group by
            percents.parent_id,
            percents.child_id)

        select
          parent_id user_id,
          sum(kb) value
        from
          kb
        group by
          parent_id) kb
      on kb.user_id = results.user_id
    set
      results.kb = kb.value
    where
      results.period_id = current_period_id;

  end;

