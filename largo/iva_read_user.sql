create
    definer = iva@`%` procedure iva_read_user(in value varchar(255))
begin

  declare param_user_id int;

  if iva_is_numeric(value) = 0 then
    set param_user_id = iva_get_user_id(value);
  else
    set param_user_id = cast (value as int);
  end if;

  select
    user.id,
    user.email,
    user.name,
    user.surname surname,
    user.package_name package,
    user.has_business,
    iva_format_date(user.package_expires, true) package_expire,
    parent.id parent_id,
    parent.email parent_email,
    parent.name parent_name,
    parent.surname parent_surname,
    (select count(id) from iva_user_roots where parent_id = user.id) child_count,
    (select count(id) from iva_cmb_orders where user_id = user.id and status = 'completed') cmb_orders_count,
    (select count(id) from iva_mp_orders where user_id = user.id and status = 'completed') mp_orders_count
  from
    iva_users user

    join iva_users parent
    on parent.id = user.parent_id
  where
    user.id = param_user_id;

end;

