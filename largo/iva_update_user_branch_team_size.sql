create
    definer = iva@`%` procedure iva_update_user_branch_team_size(in current_parent_id int)
begin

  update
    largo.iva_users
  set
    team_size = (
      select
        count(child_id)
      from
        iva_user_roots
      where
        parent_id = current_parent_id)
  where
    id = current_parent_id;

  update
    largo.iva_users users

    join (
      select
        roots.parent_id user_id,
        count(children.id) team_size
      from
        largo.iva_user_roots roots

        join largo.iva_user_roots children
        on children.parent_id = roots.parent_id
      where
        roots.child_id = current_parent_id
      group by
        roots.parent_id) tbl
    on tbl.user_id = users.id
set
  users.team_size = tbl.team_size;

  update
    largo.iva_user_branches branches

    join largo.iva_users users
    on users.id = branches.child_id
  set
    branches.team_size = users.team_size
  where
    branches.is_trash = false
    and branches.child_id = current_parent_id;

  update
    largo.iva_user_branches branches

    join largo.iva_users users
    on users.id = branches.child_id
  set
    users.team_size = (
      select
        count(roots.child_id)
      from
        largo.iva_user_roots roots
      where
        roots.parent_id = users.id)
  where
    branches.is_trash = false
    and branches.parent_id = current_parent_id;

  update
    largo.iva_user_branches parents

    join largo.iva_user_branches children
    on children.is_trash = false
      and children.child_id = parents.child_id

    join largo.iva_users users
    on users.id = children.child_id
  set
    children.team_size = users.team_size
  where
    parents.is_trash = false
    and parents.parent_id = current_parent_id;

end;

