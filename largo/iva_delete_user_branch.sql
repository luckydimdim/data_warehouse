create
    definer = iva@`%` procedure iva_delete_user_branch(in current_user_id int)
begin

  delete from
    iva_user_branches
  where
    is_trash = false
    and child_id = current_user_id;
end;

