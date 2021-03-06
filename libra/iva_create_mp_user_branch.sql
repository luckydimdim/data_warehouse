create
    definer = iva@`%` procedure iva_create_mp_user_branch(in current_order_id  int,
                                                          in current_period_id int)
begin
  declare current_order_created datetime;

  if current_period_id is null then
    set current_period_id = iva_get_period_id(null);
  end if;

  call iva_delete_mp_order_customer_branch(current_order_id, current_period_id);

  set current_order_created = (
    select
      created
    from
      iva_mp_orders
    where
      order_id = current_order_id);

  insert iva_mp_user_branches
    (parent_id, child_id, child_package_name, depth, order_id, order_created, period_id)
  select
    parents.parent_id,
    children.parent_id,
    users.package_name,
    children.depth - parents.depth - 1 depth,
    current_order_id,
    current_order_created,
    current_period_id
  from
    iva_mp_user_roots parents

    join iva_mp_user_roots children
    on children.period_id = current_period_id
      and children.order_id = current_order_id
      and children.child_id = parents.child_id
      and children.depth > parents.depth

    join iva_users users
    on users.user_id = children.parent_id
  where
    parents.period_id = current_period_id
    and parents.order_id = current_order_id
  group by
    parents.parent_id,
    children.parent_id;

  insert iva_mp_user_branches
    (parent_id, child_id, child_package_name, depth, order_id, order_created, period_id)
  select
    parents.parent_id,
    children.child_id,
    users.package_name,
    children.depth - parents.depth,
    current_order_id,
    current_order_created,
    current_period_id
  from
    iva_mp_user_roots children

    join iva_users users
    on users.user_id = children.child_id

    join iva_mp_user_roots parents
    on parents.period_id = current_period_id
      and parents.order_id = current_order_id
      and parents.child_id = children.child_id
  where
    children.period_id = current_period_id
    and children.order_id = current_order_id
    and children.is_leaf = true
    and (parents.parent_id, children.child_id) not in (
      select
        parent_id,
        child_id
      from
        iva_mp_user_branches
      where
        order_id = current_order_id)
  group by
    parents.parent_id,
    children.child_id,
    children.depth,
    parents.depth;

  update
    iva_mp_user_branches branches

    join (
      select
        orders.user_id,
        sum( packages.package_price ) / 60 points,
        sum( packages.package_price ) money
      from
        iva_mp_orders orders

        join iva_mp_order_positions positions
        on positions.order_id = orders.order_id

        join largo.iva_mp_position_packages packages
        on packages.total_position_id = positions.total_id
      where
        orders.period_id = current_period_id
      group by
        orders.user_id) tbl
    on tbl.user_id = branches.child_id
  set
    branches.is_new = true,
    branches.points = tbl.points,
    branches.money = tbl.money
  where
    branches.order_id = current_order_id;

  insert iva_mp_user_branches
    (parent_id, child_id, child_package_name, depth, order_id, order_created,
     period_id, is_box, box_order_id, points, money, is_new)
  select
    children.parent_id,
    children.child_id,
    users.package_name,
    if (children.parent_id = children.child_id, 0, children.depth + 1) depth,
    current_order_id,
    current_order_created,
    current_period_id,
    true is_box,
    orders.id,
    sum(positions.amount) / 60,
    sum(positions.amount),
    true is_new
  from
    iva_mp_orders orders

    join iva_mp_order_positions positions
    on positions.order_id = orders.order_id

    left join largo.iva_mp_position_packages packages
    on packages.total_position_id = positions.total_id

    join iva_mp_user_branches children
    on children.order_id = current_order_id
      and children.child_id = orders.user_id

    join iva_users users
    on users.user_id = children.child_id
  where
    orders.period_id = current_period_id
    and packages.id is null
    and orders.created <= order_created
  group by
    children.parent_id,
    children.child_id,
    orders.id;

  insert iva_mp_user_branches
    (parent_id, child_id, child_package_name, depth, order_id, order_created,
     period_id, is_box, box_order_id, points, money, is_new)
  select
    orders.user_id,
    orders.user_id,
    users.package_name,
    0 depth,
    current_order_id,
    current_order_created,
    current_period_id,
    true is_box,
    orders.id,
    sum(positions.amount) / 60,
    sum(positions.amount),
    true is_new
  from
    iva_mp_orders orders

    join iva_users users
    on users.user_id = orders.user_id

    join iva_mp_order_positions positions
    on positions.order_id = orders.order_id

    left join largo.iva_mp_position_packages packages
    on packages.total_position_id = positions.total_id
  where
    orders.period_id = current_period_id
    and packages.id is null
    and orders.created <= current_order_created
  group by
    orders.id;

  update
    iva_mp_user_branches branches

    left join iva_mp_accruals parent_accruals
    on parent_accruals.period_id = current_period_id
      and parent_accruals.user_id = branches.parent_id

    left join iva_mp_accruals child_accruals
    on child_accruals.period_id = current_period_id
      and child_accruals.user_id = branches.child_id
      and branches.parent_id <> branches.child_id
  set
    parent_go = ifnull(parent_accruals.go, 0),
    parent_kp = ifnull(parent_accruals.kp, 0),
    child_go = ifnull(child_accruals.go, 0),
    child_kp = ifnull(child_accruals.kp, 0)
  where
    branches.order_id = current_order_id;

  update
    iva_mp_user_branches
  set
    parent_ignored = true,
    child_ignored = true
  where
    order_id = current_order_id
    and depth = 0
    and parent_id <> child_id
    and parent_kp <= child_kp;

  update
    iva_mp_user_branches origins

    join iva_mp_user_branches children
    on children.order_id = origins.order_id
      and children.parent_id = origins.child_id
  set
    children.child_ignored = true
  where
    origins.order_id = current_order_id
    and origins.parent_ignored = true;

  update
    iva_mp_user_branches branches

    join (
      select
        parent_id,
        parent_go - sum(points) points
      from (
        select
          parents.parent_id,
          parents.parent_go,
          positions.points
        from
          iva_mp_user_branches origins

          join iva_mp_user_branches parents
          on parents.order_id = origins.order_id
            and parents.child_id = origins.child_id
            and parents.parent_id <> origins.child_id
            and parents.parent_kp <= origins.child_kp

          join iva_mp_user_branches positions
          on positions.order_id = origins.order_id
            and positions.parent_id = origins.child_id
            and positions.child_ignored = true
            and positions.points > 0
        where
          origins.order_id = current_order_id
          and origins.parent_ignored = true
        group by
          parents.parent_id,
          positions.child_id,
          positions.box_order_id) tbl
      group by
        parent_id) tbl
    on tbl.parent_id = branches.parent_id
  set
    branches.parent_go = tbl.points
  where
    branches.order_id = current_order_id;

  update
    iva_mp_user_branches parents

    join iva_mp_user_branches children
    on children.order_id = parents.order_id
      and children.child_id = parents.parent_id
      and children.child_id <> children.parent_id
  set
    children.child_go = parents.parent_go
  where
    parents.order_id = current_order_id;

  update
    iva_mp_user_branches
  set
    is_first_line = (depth = 0)
  where
    order_id = current_order_id;


  update
    iva_mp_user_branches branches

    join (
      with roots (user_id, depth) as (
        select
          parent_id,
          depth
        from
          iva_mp_user_roots
        where
          order_id = current_order_id
        group by
          parent_id)
      select
        branches.parent_id,
        branches.parent_kp,
        roots.depth,
        branches.child_id,
        branches.child_kp,
        lanes.parent_id lane_parent_id,
        max(accruals.kp) max_kp
      from
        iva_mp_user_branches branches

        join roots
        on roots.user_id = branches.parent_id

        join iva_mp_user_roots lanes
        on lanes.order_id = branches.order_id
          and lanes.child_id = branches.child_id
          and lanes.depth > roots.depth

        join iva_mp_accruals accruals
        on accruals.period_id = current_period_id
          and accruals.user_id = lanes.parent_id
      where
        branches.order_id = current_order_id
        and branches.is_box = false
      group by
        branches.parent_id,
        branches.child_id
      having
        max_kp <= branches.child_kp) tbl
    on tbl.parent_id = branches.parent_id
      and tbl.child_id = branches.child_id
  set
    branches.is_first_line = true
  where
    branches.order_id = current_order_id
    and branches.is_box = false;

end;

