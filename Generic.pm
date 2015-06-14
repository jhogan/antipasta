package Generic;
sub is_keyword{
	my $word = shift;
	my $exclude = shift;
	my $is_keyword ;
	if ($word =~ /(END|THEN|ABS|WRITE|ASC|BLOCK READ|BLOCK WRITE|BUILD|CALL|CHAIN|CHAIN READ|CHAIN WRITE|CHDIR|CHF|CH|CHR|CKY|CLOSE|CONST|DATA|AS|DEF|FN[a-zA-Z]|DIM|DTCHECK|DTNOW|DTPART|DTSERIAL|DTVALUE|END|ENTER|EXP|FOR|FLN|FRA|GDIM|GET|GOSUB|GOTO|IF|ERR|INCLUDE|INPUT|INT|IXR|KEY|KILL|LEN|LET|LKY|LOG|MAN|MAT READ|MAT WRITE|NEXT|NOT|ON|OPEN|POS|PRINT|PRN|RANDOM|READ|REM|RESTOR|RETURN|RND|SEARCH|SGN|SIGNAL|SIN|SIZEOF|SPAWN|SPC|SQR|STOP|SUSPEND|SWAP|SYSTEM|TAN|TMADD|TMCHECK|TMNOW|TMSERIAL|TMVALUE|TRAP|AND|OR|ELSE|TO|MAT)/)	{
	$is_keyword = "TRUE";
	}
	if ($word =~ /($exclude)/){$is_keyword = undef;}
	return $is_keyword;
}
sub I_quote{
	$str = shift;
	for ($i=0; $i<=length($str);$i++){
		$char = substr($line_no_id,$i,1);
		if ($in_double_quotes){ 
			if ($char eq "\"") {$in_double_quotes = 0; next;} 
		}elsif ($in_double_quotes){ 
			if ($char eq "'") {$in_single_quotes = 0 ; next;} 
		}else{ 
			if ($char eq "'") {$in_single_quotes = 1 ; next;} 
			if ($char eq "\"") {$in_double_quotes = 1; next;} 
		}
	}
	return ($in_double_quotes || $in_single_quotes);
}
1;
