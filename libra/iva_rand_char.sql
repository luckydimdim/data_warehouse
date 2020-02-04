create
    definer = iva@`%` function iva_rand_char() returns char
begin

  IF RAND() <= 0.5 THEN
    return CHAR( 97 + 25*rand() ) ;
  ELSE
    return CHAR( 65 + 25*rand() ) ;
  END IF;

end;

