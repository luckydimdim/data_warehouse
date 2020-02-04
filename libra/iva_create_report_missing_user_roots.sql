create
    definer = iva@`%` procedure iva_create_report_missing_user_roots()
begin
  select distinct
    concat('call iva_update_user(', u1.value_id, ');') update_user
  from
    iva.b_uts_user u1

    join iva.b_user uu
    on uu.id = u1.value_id
      and uu.active = 'Y'

    left join libra.iva_users u3
    on u3.user_id = u1.value_id

    left join largo.iva_users u2
    on u2.id = u1.value_id

    left join largo.iva_user_roots roots
    on roots.child_id = u1.value_id
      and roots.is_leaf = true
  where
    u2.parent_id <> u1.uf_invate
    or roots.parent_id <> u1.uf_invate
    or u3.partner_id <> u1.uf_invate;
end;

