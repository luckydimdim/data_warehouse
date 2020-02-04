create
    definer = iva@`%` function iva_get_user_id(current_email varchar(255)) returns int
begin
  return (
    select
      id
    from
      iva_users
    where
      login = current_email
    limit 1);
end;

