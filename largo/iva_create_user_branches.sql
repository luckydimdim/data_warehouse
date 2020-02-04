create
    definer = iva@`%` procedure iva_create_user_branches(in current_parent_id int,
                                                         in current_period_id int)
begin

  if current_period_id is null then
    set current_period_id = iva_get_period_id(null);
  end if;

  if current_parent_id is null then
    set current_parent_id = 1;
  end if;


  delete
    children
  from
    iva_user_branches parents

    join iva_user_branches children
    on children.is_trash = false
      and children.child_id = parents.child_id
  where
    parents.is_trash = false
    and parents.parent_id = current_parent_id;

  insert iva_user_branches
    (parent_id, child_id, depth, is_leaf, partner_id, email, phone, package_id, package_name, has_business, subscription_expire, is_subscription_expired,
     name, surname, name_and_surname, city, birthdate, team_size, generation, activation, go, o1l, osv, bo, ko,
     k, qualification_name, kp, ks, cmb, lb, kb, bs, gb, sb, mp_points, mp_money, cmb_points, cmb_money, total_points, total_money, is_password_expired, is_locked)
  select
    children.parent_id, children.child_id, children.depth, children.is_leaf, users.parent_id,
    users.login, ifnull(users.phone, ''), users.package_id,
    iva_get_package_name(users.package_id), users.has_business,
    users.package_expires, if (users.package_expires is not null and users.package_expires > now(), false, true), ifnull(users.name, ''), ifnull(users.surname, ''), concat_ws(' ', users.name, users.surname),
    ifnull(users.city, ''), null , 0 team_size,
    grand_children.depth - children.depth + 1, ifnull(profits.activation, false), ifnull(profits.go, 0),
    ifnull(profits.o1l, 0), ifnull(profits.osv, 0), ifnull(profits.bo, 0), ifnull(profits.ko, 0),
    ifnull(profits.k, 0), iva_get_qualification_name( ifnull(profits.k, 0) ), ifnull(profits.kp, 0),
    ifnull(profits.ks, 0), ifnull(profits.cmb, 0), ifnull(profits.lb, 0), ifnull(profits.kb, 0),
    ifnull(profits.bs, 0), ifnull(profits.gb, 0), ifnull(profits.sb, 0), ifnull(profits.mp_points, 0),
    ifnull(profits.mp_money, 0), ifnull(profits.cmb_points, 0), ifnull(profits.cmb_money, 0),
    ifnull(profits.mp_points, 0) + ifnull(profits.cmb_points, 0), ifnull(profits.mp_money, 0) + ifnull(profits.cmb_money, 0), users.is_password_expired,
    (select
       (select user_id from largo.iva_mp_orders where status = 'completed' and user_id = children.child_id and price > 0
        union
        select user_id from largo.iva_cmb_orders where status = 'completed' and user_id = children.child_id and price > 0) is not null
      or iva_get_package_name(users.package_id) <> 'Silver')
  from
    iva_user_roots parents

    join iva_user_roots children
    on children.child_id = parents.child_id

    join iva_user_roots grand_children
    on grand_children.child_id = children.child_id
      and grand_children.is_leaf = true

    join iva_users users
    on users.id = parents.child_id

    left join iva_profits profits
    on profits.user_id = parents.child_id
      and profits.period_id = current_period_id
  where
    parents.parent_id = current_parent_id;

  call iva_update_user_branch_team_size(current_parent_id);

end;

