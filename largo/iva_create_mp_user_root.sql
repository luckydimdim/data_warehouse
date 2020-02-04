create
    definer = iva@`%` procedure iva_create_mp_user_root(in current_order_id  int,
                                                        in current_period_id int)
begin

  if current_period_id is null then
    set current_period_id = iva_get_period_id(null);
  end if;

  delete from largo.iva_mp_customer_roots where period_id = current_period_id;

  insert largo.iva_mp_customer_roots
    (period_id, depth, is_leaf, child_is_new, parent_id, parent_email, parent_name_and_surname, parent_package_name, parent_kp,
     parent_go, parent_o1l, parent_bo, parent_lb, parent_kb, parent_sb, parent_bs, parent_gb, parent_points,
     parent_money, child_id, child_email, child_name_and_surname, child_package_name, child_kp, child_go,
     child_o1l, child_bo, child_lb, child_kb, child_sb, child_bs, child_gb, child_points, child_money)
  select
    current_period_id,
    tree.depth,
    tree.is_leaf,
    tree.is_leaf,
    tree.parent_id,
    parent.login parent_email,
    concat_ws(' ', parent.name, parent.surname) parent_name_and_surname,
    parent.package_name parent_package,
    ifnull(parent_profits.kp, 0) parent_kp,
    ifnull(parent_profits.go, 0) parent_go,
    ifnull(parent_profits.o1l, 0) parent_o1l,
    ifnull(parent_profits.bo, 0) parent_bo,
    ifnull(parent_profits.lb, 0) parent_lb,
    ifnull(parent_profits.kb, 0) parent_kb,
    ifnull(parent_profits.sb, 0) parent_sb,
    ifnull(parent_profits.bs, 0) parent_bs,
    ifnull(parent_profits.gb, 0) parent_gb,
    ifnull(parent_profits.mp_points, 0) parent_points,
    ifnull(parent_profits.mp_money, 0) parent_money,
    tree.child_id,
    child.login child_email,
    concat_ws(' ', child.name, child.surname) child_name_and_surname,
    child.package_name child_package,
    ifnull(child_profits.kp, 0) child_kp,
    ifnull(child_profits.go, 0) child_go,
    ifnull(child_profits.o1l, 0) child_o1l,
    ifnull(child_profits.bo, 0) child_bo,
    ifnull(child_profits.lb, 0) child_lb,
    ifnull(child_profits.kb, 0) child_kb,
    ifnull(child_profits.sb, 0) child_sb,
    ifnull(child_profits.bs, 0) child_bs,
    ifnull(child_profits.gb, 0) child_gb,
    ifnull(child_profits.mp_points, 0) child_points,
    ifnull(child_profits.mp_money, 0) child_money
  from
    libra.iva_mp_user_roots tree

    join largo.iva_users child
    on child.id = tree.child_id

    join largo.iva_users parent
    on parent.id = tree.parent_id

    left join largo.iva_profits child_profits
    on child_profits.period_id = current_period_id
      and child_profits.user_id = child.id

    left join largo.iva_profits parent_profits
    on parent_profits.period_id = current_period_id
      and parent_profits.user_id = parent.id
  where
    tree.order_id = current_order_id;

  insert largo.iva_mp_customer_roots
    (period_id, depth, is_leaf, child_is_new, parent_id, parent_email, parent_name_and_surname, parent_package_name, parent_kp,
     parent_go, parent_o1l, parent_bo, parent_lb, parent_kb, parent_sb, parent_bs, parent_gb, parent_points,
     parent_money, child_id, child_email, child_name_and_surname, child_package_name, child_kp, child_go,
     child_o1l, child_bo, child_lb, child_kb, child_sb, child_bs, child_gb, child_points, child_money,
     is_box, box_order_id, box_order_name, box_points)
  select
    tree.period_id, depth + 1, true, true,
    child_id, child_email, child_name_and_surname, child_package_name, child_kp, child_go,
    child_o1l, child_bo, child_lb, child_kb, child_sb, child_bs, child_gb, child_points, child_money,
    child_id, child_email, child_name_and_surname, child_package_name, child_kp, child_go,
    child_o1l, child_bo, child_lb, child_kb, child_sb, child_bs, child_gb, child_points, child_money,
    true is_box, transactions.order_id, 'Заказ Тотал-Лайф', transactions.o1l_package
  from
    libra.iva_mp_transactions transactions

    join largo.iva_mp_customer_roots tree
    on tree.period_id = current_period_id
      and tree.child_id = transactions.source_user_id
      and tree.is_leaf = true
  where
    transactions.period_id = current_period_id
    and transactions.type = 'sale'
    and transactions.o1l_package > 0;

  update
    largo.iva_mp_customer_roots roots

    join largo.iva_mp_orders orders
    on orders.period_id = roots.period_id
      and orders.user_id = roots.parent_id
      and orders.order_package_id is not null
  set
    parent_is_new = true
  where
    roots.period_id = current_period_id;

  update
    largo.iva_mp_customer_roots
  set
    is_leaf = false
  where
    period_id = current_period_id;

  update
    largo.iva_mp_customer_roots
  set
    is_leaf = true
  where
    period_id = current_period_id
    and (child_id, depth) in (
      select
        child_id,
        max(depth) max_depth
      from
        largo.iva_mp_customer_roots
      where
        period_id = current_period_id
      group by
        child_id);

end;

