create
    definer = iva@`%` procedure iva_create_report_missing_users()
begin
  select distinct
    users.id,
    concat('call iva_create_user(', users.id, ');') create_user
  from
    iva.b_user users

    left join largo.iva_users iu
    on iu.id = users.id

    left join largo.iva_user_roots roots
    on roots.child_id = users.id

    left join largo.iva_user_branches branches
    on branches.is_trash = false
      and branches.child_id = users.id
  where
    users.active = 'Y'
    and (iu.id is null
      or (roots.id is null and users.id <> 1)
      or (branches.id is null and users.id <> 1));
end;

