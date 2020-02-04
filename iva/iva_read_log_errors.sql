create
    definer = iva@`%` procedure iva_read_log_errors()
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
    severity = 'ERROR'
  order by
    id desc
  limit
    1000;

end;

