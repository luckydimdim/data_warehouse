create
    definer = iva@`%` procedure iva_create_report_broken_roots_and_branches()
begin

  declare current_period_id int;

  set current_period_id = iva_get_period_id(null);

  select distinct
    roots.child_id,
    concat('call largo.iva_delete_user_branch(', roots.child_id, '); call largo.iva_create_user_branch(', roots.child_id, ');') repair
  from
    largo.iva_user_roots roots

    left join largo.iva_user_branches branches
    on branches.is_trash = false
      and branches.parent_id = roots.parent_id
      and branches.child_id = roots.child_id
  where
    branches.id is null
  union all
  select distinct
    branches.child_id,
    concat('call largo.iva_update_user_root(', branches.child_id, '); call largo.iva_delete_user_branch(', branches.child_id, '); call largo.iva_create_user_branch(', branches.child_id, ');') repair
  from
    largo.iva_user_branches branches

    left join largo.iva_user_roots roots
    on roots.parent_id = branches.parent_id
      and roots.child_id = branches.child_id
  where
    branches.is_trash = false
    and roots.id is null;
end;

