create
    definer = iva@`%` procedure iva_read_user_branches(in current_user_id int)
begin
  select
    users.id partner_id,
    users.login partner_email,
    branches.child_id user_id,
    branches.email user_email,
    branches.team_size,
    branches.phone,
    branches.package_name,
    branches.is_subscription_expired,
    branches.name_and_surname,
    branches.city,
    branches.birthdate,
    branches.activation,
    branches.go,
    branches.o1l,
    branches.osv,
    branches.bo,
    branches.generation,
    branches.qualification_name,
    branches.ko,
    branches.kp,
    branches.cmb,
    branches.lb,
    branches.bs,
    branches.gb,
    branches.sb,
    branches.mp_points,
    branches.mp_money,
    branches.cmb_points,
    branches.cmb_money,
    branches.total_points,
    branches.total_money
  from
    largo.iva_user_branches branches

    join largo.iva_users users
    on users.id = branches.partner_id
  where
    branches.is_trash = false
    and branches.parent_id = current_user_id
  order by
    generation asc;
end;

