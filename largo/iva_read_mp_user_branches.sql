create
    definer = iva@`%` procedure iva_read_mp_user_branches(in current_user_id int)
begin
  select
    *
  from
    iva_user_branches
  where
    is_trash = false
    and parent_id = current_user_id
  order by
    generation asc;
end;

