create
    definer = iva@`%` procedure iva_create_mp_osv_accruals(in current_order_id  int,
                                                           in current_period_id int)
begin


    update
      iva_mp_accruals results

      join (
        with parent_go (user_id, value) as (
          select
            target_user_id,
            sum(go_package + go_subscribe)
          from
            iva_mp_transactions
          where
            period_id = current_period_id
          group by
            target_user_id),

          child_go (user_id, value) as (
            select
              source_user_id,
              sum(o1l_package + o1l_subscribe)
            from
              iva_mp_transactions
            where
              period_id = current_period_id
              and type <> 'sale'
            group by
              source_user_id),

          box_go (user_id, value) as (
            select
              bonus.source_user_id,
              max( bonus.go_package + bonus.go_subscribe )
            from
              iva_mp_transactions bonus
            where
              bonus.period_id = current_period_id
              and bonus.type = 'sale'
              and bonus.source_user_id = bonus.target_user_id
            group by
              bonus.source_user_id),

          base_go (parent_id, parent_go, child_id, type) as (
            select
              parent.parent_id,
              results.go parent_go,
              ifnull(child_next.parent_id, child_current.child_id) child_id,
              'user' type
            from
              iva_mp_transactions bonus

              join iva_mp_accruals results
              on results.period_id = current_period_id
                and results.user_id = bonus.target_user_id

              join iva_mp_user_roots parent
              on parent.order_id = current_order_id
                and parent.parent_id = bonus.target_user_id

              left join iva_mp_user_roots child_next
              on child_next.order_id = current_order_id
                and child_next.child_id = parent.child_id
                and child_next.depth = parent.depth + 1

              left join iva_mp_user_roots child_current
              on child_current.order_id = current_order_id
                and child_current.child_id = parent.child_id
                and child_current.depth = parent.depth
                and child_current.is_leaf = true
            where
              bonus.order_id = current_order_id
            group by
              parent.parent_id,
              ifnull(child_next.parent_id, child_current.child_id)

            union

            select
              parent.child_id parent_id,
              results.go parent_go,
              null child_id,
              'box' type
            from
              iva_mp_transactions bonus

              join iva_mp_accruals results
              on results.period_id = current_period_id
                and results.user_id = bonus.target_user_id

              join iva_mp_user_roots parent
              on parent.order_id = current_order_id
                and parent.child_id = bonus.target_user_id
            where
              bonus.period_id = current_period_id
              and bonus.order_id = current_order_id
              and bonus.source_user_id = bonus.target_user_id
            group by
              parent.child_id)

        select
          base_go.parent_id,
          base_go.parent_go,
          base_go.child_id,
          ifnull(parent_go.value, 0) + ifnull(child_go.value, 0) go,
          max( ifnull(parent_go.value, 0) + ifnull(child_go.value, 0) ) max_go,
          ifnull(parent_go.value, 0) aaa,
          ifnull(child_go.value, 0),
          ifnull(box_go.value, 0),
          greatest( max( ifnull(parent_go.value, 0) + ifnull(child_go.value, 0) ), ifnull(box_go.value, 0) ) osv,
          base_go.parent_go - greatest( max( ifnull(parent_go.value, 0) + ifnull(child_go.value, 0) ), ifnull(box_go.value, 0) ) bo
        from
          base_go

          left join box_go
          on box_go.user_id = base_go.parent_id

          left join parent_go
          on parent_go.user_id = base_go.child_id
            and base_go.type = 'user'

          left join child_go
          on child_go.user_id = base_go.child_id
        group by
          base_go.parent_id) nested
      on nested.parent_id = results.user_id
    set
      results.osv = nested.osv
    where
      results.period_id = current_period_id;

  end;

