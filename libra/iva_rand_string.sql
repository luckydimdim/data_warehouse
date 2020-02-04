create
    definer = iva@`%` function iva_rand_string(len int) returns varchar(255)
BEGIN
  SET @n = 0;
  SET @res = '' ;
  REPEAT
    SET @res = concat( @res, iva_rand_char() ) ;
    set @n = @n + 1 ;
  UNTIL @n >= len END REPEAT;
  return @res ;
END;

