create
    definer = iva@`%` procedure iva_create_user_transfer(in user_id       int,
                                                         in old_parent_id int,
                                                         in new_parent_id int,
                                                         in manager_id    int,
                                                         in comment       varchar(255))
begin
  insert iva_user_transfers
    (user_id, old_parent_id, new_parent_id, manager_id, comment)
  values
    (user_id, old_parent_id, new_parent_id, manager_id, comment);
end;

