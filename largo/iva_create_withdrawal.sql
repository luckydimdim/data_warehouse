create
    definer = iva@`%` procedure iva_create_withdrawal(in current_request_id int)
begin
    insert iva_withdrawals (
      id,
      created,
      user_id,
      login,
      name_and_surname,
      card_number,
      card_account,
      rs,
      inn,
      card_bik,
      bank_bik,
      original_name,
      face_type,
      status,
      comment,
      amount,
      comission,
      vat,
      available_amount,
      amount_after_vat,
      period_id)
    select
      requests.id,
      requests.created,
      requests.user_id,
      users.login,
      concat_ws(' ', users.name, users.surname) name_and_surname,
      requisites.card_number,
      requisites.card_account,
      requisites.rs,
      requisites.inn,
      requisites.card_bik,
      requisites.bank_bik,
      requisites.user_name,
      requisites.face_type,
      requests.status,
      requests.comment,
      requests.amount,
      requests.comission,
      requests.vat,
      requests.available_amount,
      requests.amount_after_vat,
      iva_get_period_id(requests.created)
    from
      libra.iva_withdrawals requests

      join iva_users users
      on users.id = requests.user_id

      join iva_user_requisites requisites
      on requisites.user_id = users.id
    where
      requests.id = current_request_id

  on duplicate key update
      largo.iva_withdrawals.created = requests.created,
      largo.iva_withdrawals.user_id = requests.user_id,
      largo.iva_withdrawals.login = users.login,
      largo.iva_withdrawals.name_and_surname = concat_ws(' ', users.name, users.surname),
      largo.iva_withdrawals.card_number = requisites.card_number,
      largo.iva_withdrawals.card_account = requisites.card_account,
      largo.iva_withdrawals.rs = requisites.rs,
      largo.iva_withdrawals.inn = requisites.inn,
      largo.iva_withdrawals.card_bik = requisites.card_bik,
      largo.iva_withdrawals.bank_bik = requisites.bank_bik,
      largo.iva_withdrawals.original_name = requisites.user_name,
      largo.iva_withdrawals.face_type = requisites.face_type,
      largo.iva_withdrawals.status = requests.status,
      largo.iva_withdrawals.comment = requests.comment,
      largo.iva_withdrawals.amount = requests.amount,
      largo.iva_withdrawals.comission = requests.comission,
      largo.iva_withdrawals.vat = requests.vat,
      largo.iva_withdrawals.available_amount = requests.available_amount,
      largo.iva_withdrawals.amount_after_vat = requests.amount_after_vat,
      largo.iva_withdrawals.period_id = iva_get_period_id(requests.created);

end;

