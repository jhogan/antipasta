package Lines;
use Mod;
use Line;

sub new {
    my $class = shift;
    my $self = {};
    bless $self, $class;
    return $self;
}

sub load_mod{
    my $self = shift;
    my $mod = shift;
    $self->{_props}->{_mod} = $mod;
    $self->{_props}->{_line_count} = 0;
    my $path = $self->mod->path;
    my $in_double_quotes;
    my $in_single_quotes;	
    my $line; my $bas_line_id; my $line_no_id; my $char; my $in_comment;
    my $BOL;
    open (MOD,$path) or die "Cant open because:\n$!\n";
    while (<MOD>){
        chomp;
        uc;
		/^\W*(([0-9]+ )|([A-Z][A-Z0-9]*:))/;

		if ($1){
			$bas_line_id = substr($1,0,(length($1)-1));
			$line_no_id = $';
		}else{
			$line_no_id = $_;
		}

		$length_of_line_no_id = length($line_no_id);
		$in_double_quotes = $in_single_quotes = $in_comment = undef;
		$BOL=0;

		for ($i=0; $i<=$length_of_line_no_id;$i++){
			$char = substr($line_no_id,$i,1);
			if (!$in_comment){
				   if ($char eq "\"") {$in_double_quotes = !$in_double_quotes ; next;} 
				elsif ($char eq "'") {$in_single_quotes = !$in_single_quotes ; next;} 
			}

			if (!$in_double_quotes && !$in_single_quotes && (substr($line_no_id,$i,1) eq "!" || substr($line_no_id,$i,3) eq "REM")){
					$in_comment =  "TRUE";
			}

			if ((!$in_double_quotes && !$in_single_quotes && $char eq "\\" && !$in_comment) ||  $i==$length_of_line_no_id){

				if (substr($line_no_id,$i,2) eq "\\\\") {substr($line_no_id,$i,1) = " "; next;}
				if ($char eq "\\") {substr($line_no_id,$i,1) = " ";}                
			
				$line = Line->new(substr($line_no_id,$BOL,$i-$BOL), $bas_line_id, $self->{_props}->{_line_count}, $self->mod);

				$self->add($line);

	 			$BOL = $i;
				$bas_line_id="";
	   		 }
		}
	}
	if ($DEBUG){
				foreach $line ( @{$self->{_col}} ) {

							print "---line_no_id:" . $line->line_no_id(). "----\n";
							print "BasID:" . $line->bas_line_id . "\t";
							print "code:" . $line->Code()  . "\t";
							print "comment:" . $line->comment . "\n";
							print ("is_comment:" . $line->is_comment ."\t");
							print ("is_return:" . $line->is_return ."\n");
							print ("is_gosub:" . $line->is_gosub ."\n");
							if ($line->is_gosub){
								print ("    gosub_bas_id:" . $line->gosub_this->bas_line_id ."\t");
								print ("    gosub_code:" . $line->gosub_this->Code ."\t");
								print ("    gosub_rem:" . $line->gosub_this->comment ."\n");
							}
							print ("is_goto:" . $line->is_goto ."\n");
							if ($line->is_goto){
								print ("    goto_bas_id:" . $line->goto_this->bas_line_id ."\t");
								print ("    goto_code:" . $line->goto_this->Code ."\t");
								print ("    goto_rem:" . $line->goto_this->comment ."\n");
							}
							print ("\n");
					}	
	}
}
sub add{
    my $self = shift; my $line =shift;
	my @simple_col, my $simple_mod_seq;
	my $lbound; my $ubound;
	if ($self->{_props}->{_line_count}  == undef){$self->{_props}->{_line_count} = 0}
        if ($self->{_props}->{_lbound} == undef){$self->{_props}->{_lbound} = $line->mod_seq;}
	if ($self->{_props}->{_lbound} > $line->mod_seq)  {
		$self->{_props}->{_lbound} = $line->mod_seq;
	}
    my $bas_line_id = $line->bas_line_id;
	$self->{_col}->[$line->mod_seq] = $line;
	$self->{_props}->{_ubound} = $line->mod_seq if $self->{_props}->{_ubound} < $line->mod_seq;
	$self->{_props}->{_line_count}++;
	$self->{_props}->{_as_added}->[$self->{_props}->{_line_count}] = $line;
	$lbound = $self->{_props}->{_lbound}; $ubound = $self->{_props}->{_ubound};
	if ($line->dimention_code){push @{$self->{_dim_line_col}}, $line;}
		

    if ($line->mod_seq >= $ubound){
		push @{$self->{_simple_col}}, $line;
    }elsif($line->mod_seq < $lbound){
		unshift @{$self->{_simple_col}}, $line;
	}else{
		foreach $simple (@{$self->{_simple_col}}){
			$simple_mod_seq = @{$self->{_simple_col}}[$simple]->mod_seq;
			if (line->mod_seq > $simple_mod_seq ){splice @{$self->{_simple_col}}, @simple, 0, $line;}
		}
	}
	#print scalar @{$self->{_simple_col}};
	#print "\t" . $line->full_line . "\n";
    
		
	if ($bas_line_id) {
	    if ($self->{_props}->{_item}->{$bas_line_id}){
		#duplicate basic id
		#print $self->{_props}->{_line_count} . "\t" . $bas_line_id . "\t" .  $line->full_line . "\n" ;
	    }else{
		$self->{_props}->{_item}->{$bas_line_id} = $line;
		#print $self->{_props}->{_line_count} . "\t" . $bas_line_id . "\t" .  $line->full_line . "\n" ;
	    }
	}
}

sub simple_col{
    $self = shift;
    return $self->{_simple_col};
}
sub col{
    $self = shift;
    return $self->{_col};
}
sub as_added{
    $self = shift;
	return $self->{_props}->{_as_added};
}

sub ubound{
    my $self=shift;
	$self->{_props}->{_ubound};
}
sub lbound{
    my $self=shift;
	$self->{_props}->{_lbound};
}

sub item{
   my $self = shift;
   my $bas_line_id = shift;
   return $self->{_props}->{_item}->{$bas_line_id};
}

sub line_by_bas_line_id{
	#I think this is suppossed to be sub item()
    my $self = shift;
    my $bas_line_id = $_[0];
    return $self->{_line_by_bas_line_id}->{$bas_line_id};
}
sub mod{
    my $self = shift;
    return $self->{_props}->{_mod};
}
sub count{
	my $self = shift;
	return $self->{_props}->{_line_count} - 1 
}
sub dim_lines{
	my $self = shift;
	return $self->{_dim_line_col};
}
1;
