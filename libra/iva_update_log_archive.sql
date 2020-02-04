create
    definer = iva@`%` procedure iva_update_log_archive()
begin

  insert storage.iva_log_archive select * from storage.iva_logs;
  delete from storage.iva_logs where id <= (select max(id) from storage.iva_log_archive);

end;

