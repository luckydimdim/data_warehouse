create
    definer = iva@`%` procedure iva_read_log(in value      varchar(255),
                                             in rows_count int)
begin

  if rows_count is null then
    set rows_count = 2000;
  end if;

  select
    id,
    timestamp_x,
    severity,
    audit_type_id,
    item_id,
    request_uri,
    description
  from
    storage.iva_logs
  where
    request_uri like concat('%', replace(value, '@', '%40'), '%')
    or item_id = value
    or audit_type_id = value
    or description like concat('%', replace(value, '@', '%40'), '%')
  order by
    id desc
  limit
    rows_count;

end;

