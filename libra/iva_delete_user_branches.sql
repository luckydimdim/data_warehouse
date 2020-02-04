create
    definer = iva@`%` procedure iva_delete_user_branches(in current_user_id int)
begin
  delete from
    iva_mp_user_branches
  where
    child_id = current_user_id;

  delete from
    iva_mp_user_branches
  where
    parent_id = current_user_id;
end;

