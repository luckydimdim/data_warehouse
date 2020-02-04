create
    definer = iva@`%` procedure iva_read_log(in value varchar(255))
begin

  select
    id,
    timestamp_x,
    severity,
    audit_type_id,
    item_id,
    request_uri,
    description
  from
    iva.b_event_log
  where
    request_uri like concat('%', replace(value, '@', '%40'), '%')
    or item_id = value
    or audit_type_id = value
    or description like concat('%', replace(value, '@', '%40'), '%')
  order by
    id desc
  limit
    2000;

end;

