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
    storage.iva_logs
  where
    severity = 'ERROR'
  order by
    timestamp_x desc
  limit
    1000;

end;

