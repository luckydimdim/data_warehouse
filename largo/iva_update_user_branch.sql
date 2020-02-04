create
    definer = iva@`%` procedure iva_update_user_branch(in current_user_id   int,
                                                       in current_period_id int)
proc:begin
  if current_period_id is null then
    set current_period_id = iva_get_period_id(null);
  end if;

  insert iva_user_branches
    (parent_id, child_id, depth, is_leaf, partner_id, email, phone, package_id, package_name, has_business, subscription_expire, is_subscription_expired,
     name, surname, name_and_surname, city, birthdate, team_size, generation, activation, go, o1l, osv, bo, ko,
     k, qualification_name, kp, ks, cmb, lb, kb, bs, gb, sb, mp_points, mp_money, cmb_points, cmb_money, total_points, total_money, is_password_expired, is_locked)
  select
    parents.parent_id, parents.child_id, children.depth, parents.is_leaf, users.parent_id,
    users.login, ifnull(users.phone, ''), users.package_id,
    iva_get_package_name(users.package_id), users.has_business,
    users.package_expires, if (users.package_expires is not null and users.package_expires > now(), false, true), ifnull(users.name, ''), ifnull(users.surname, ''), concat_ws(' ', users.name, users.surname),
    ifnull(users.city, ''), null , (select count(child_id) team_size from iva_user_branches where is_trash = false and parent_id = users.id),
    children.depth - parents.depth + 1, ifnull(profits.activation, false), ifnull(profits.go, 0),
    ifnull(profits.o1l, 0), ifnull(profits.osv, 0), ifnull(profits.bo, 0), ifnull(profits.ko, 0),
    ifnull(profits.k, 0), iva_get_qualification_name( ifnull(profits.k, 0) ), ifnull(profits.kp, 0),
    ifnull(profits.ks, 0), ifnull(profits.cmb, 0), ifnull(profits.lb, 0), ifnull(profits.kb, 0),
    ifnull(profits.bs, 0), ifnull(profits.gb, 0), ifnull(profits.sb, 0), ifnull(profits.mp_points, 0),
    ifnull(profits.mp_money, 0), ifnull(profits.cmb_points, 0), ifnull(profits.cmb_money, 0),
    ifnull(profits.mp_points, 0) + ifnull(profits.cmb_points, 0), ifnull(profits.mp_money, 0) + ifnull(profits.cmb_money, 0), users.is_password_expired,
    (select
       (select user_id from largo.iva_mp_orders where status = 'completed' and user_id = parents.child_id and price > 0
        union
        select user_id from largo.iva_cmb_orders where status = 'completed' and user_id = parents.child_id and price > 0) is not null
      or iva_get_package_name(users.package_id) <> 'Silver')
  from
    iva_user_roots parents

    join iva_user_roots children
    on children.child_id = parents.child_id
      and children.is_leaf = true

    join iva_users users
    on users.id = parents.child_id

    left join iva_profits profits
    on profits.period_id = current_period_id
      and profits.user_id = parents.child_id
  where
    parents.child_id = current_user_id
  on duplicate key update
    largo.iva_user_branches.depth = children.depth,
    largo.iva_user_branches.is_leaf = parents.is_leaf,
    largo.iva_user_branches.partner_id = users.parent_id,
    largo.iva_user_branches.email = users.login,
    largo.iva_user_branches.phone = ifnull(users.phone, ''),
    largo.iva_user_branches.package_id = users.package_id,
    largo.iva_user_branches.package_name = iva_get_package_name(users.package_id),
    largo.iva_user_branches.has_business = users.has_business,
    largo.iva_user_branches.subscription_expire = users.package_expires,
    largo.iva_user_branches.is_subscription_expired = if (users.package_expires is not null and users.package_expires > now(), false, true),
    largo.iva_user_branches.name = ifnull(users.name, ''),
    largo.iva_user_branches.surname = ifnull(users.surname, ''),
    largo.iva_user_branches.name_and_surname = concat_ws(' ', users.name, users.name),
    largo.iva_user_branches.city = ifnull(users.city, ''),
    largo.iva_user_branches.birthdate = null,
    largo.iva_user_branches.team_size = (select count(child_id) team_size from iva_user_branches where is_trash = false and parent_id = users.id),
    largo.iva_user_branches.generation = children.depth - parents.depth + 1,
    largo.iva_user_branches.activation = ifnull(profits.activation, false),
    largo.iva_user_branches.go = ifnull(profits.go, 0),
    largo.iva_user_branches.o1l = ifnull(profits.o1l, 0),
    largo.iva_user_branches.osv = ifnull(profits.osv, 0),
    largo.iva_user_branches.bo = ifnull(profits.bo, 0),
    largo.iva_user_branches.ko = ifnull(profits.ko, 0),
    largo.iva_user_branches.k = ifnull(profits.k, 0),
    largo.iva_user_branches.qualification_name = iva_get_qualification_name( ifnull(profits.k, 0) ),
    largo.iva_user_branches.kp = ifnull(profits.kp, 0),
    largo.iva_user_branches.ks = ifnull(profits.ks, 0),
    largo.iva_user_branches.cmb = ifnull(profits.cmb, 0),
    largo.iva_user_branches.lb = ifnull(profits.lb, 0),
    largo.iva_user_branches.kb = ifnull(profits.kb, 0),
    largo.iva_user_branches.bs = ifnull(profits.bs, 0),
    largo.iva_user_branches.gb = ifnull(profits.gb, 0),
    largo.iva_user_branches.sb = ifnull(profits.sb, 0),
    largo.iva_user_branches.mp_points = ifnull(profits.mp_points, 0),
    largo.iva_user_branches.mp_money = ifnull(profits.mp_money, 0),
    largo.iva_user_branches.cmb_points = ifnull(profits.cmb_points, 0),
    largo.iva_user_branches.cmb_money = ifnull(profits.cmb_money, 0),
    largo.iva_user_branches.total_points = ifnull(profits.mp_points, 0) + ifnull(profits.cmb_points, 0),
    largo.iva_user_branches.total_money = ifnull(profits.mp_money, 0) + ifnull(profits.cmb_money, 0),
    largo.iva_user_branches.is_password_expired = users.is_password_expired,
    largo.iva_user_branches.is_locked = (
      select
       (select user_id from largo.iva_mp_orders where status = 'completed' and user_id = parents.child_id and price > 0
        union
        select user_id from largo.iva_cmb_orders where status = 'completed' and user_id = parents.child_id and price > 0) is not null
      or iva_get_package_name(users.package_id) <> 'Silver');

    call iva_update_user_branch_team_size(current_user_id);

end;

