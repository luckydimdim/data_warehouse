create
    definer = iva@`%` procedure iva_delete_user_roots(in current_user_id int)
begin
  delete from
    iva_user_roots
  where
    child_id = current_user_id;

  delete from
    iva_user_roots
  where
    parent_id = current_user_id;
end;

