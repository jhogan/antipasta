package Line; 
use Mod;
use Generic;
use Lines;
use VarInstances;

# Constructor for creating a new Line object
sub new {
    my $class = shift;
    my $self = {};
    bless $self, $class;
    $self->_init(@_);  # Initialize the object properties
    return $self;
}

# Internal initialization method, setting up line properties
sub _init {
    my $self = shift;
    $self->{_props}->{_line_no_id} = shift;
    $self->{_props}->{_bas_line_id} = shift;
    $self->{_props}->{_mod_seq} = shift;
    $self->{_props}->{_mod} = shift;
    $self->_main_line_parser;  # Parse the main line to split into components
    $self->{_props}->{_full_line} = $self->{_props}->{_bas_line_id} . " " . $self->{_props}->{_line_no_id};
    #$self->{_props}->{_comment} = ""; 
    #$self->{_props}->{_code} = "";
	$self->{_props}->{_instances} = VarInstances->new;
}

# Getter for the basic line ID
sub bas_line_id {
    my $self = shift;
    return $self->{_props}->{_bas_line_id};
}

# Getter for the full line text
sub full_line {
    my $self = shift;
    return $self->{_props}->{_full_line};
}

# Getter for the line number ID
sub line_no_id {
    my $self = shift;
    return $self->{_props}->{_line_no_id};
}

# Main parser for the line, handling comments and quotes
sub _main_line_parser {
    my $self = shift;
    my $line_no_id = $self->line_no_id;
    my $skip_comment_keyword_by;
    my $comment_found;
    my $in_double_quotes;
    my $in_single_quotes;	
    my $char; 
    for ($i=0; $i<=length($line_no_id);$i++){
	$char = substr($line_no_id,$i,1);

	    if ($char eq "\"") {$in_double_quotes = !$in_double_quotes ; next;} 
	elsif ($char eq "\'")  {$in_single_quotes = !$in_single_quotes ; next;} 

	if (!$in_double_quotes && !$in_single_quotes){
	    if (!$comment_found){
		if (substr($line_no_id,$i,1) eq "!" || substr($line_no_id,$i,3) eq "REM"){
		    $comment_found =  "TRUE";
		    $self->{_props}->{_comment} = substr($line_no_id, $i, length($line_no_id)-$i);
		    if ($i-1 >= 1) {$self->{_props}->{_code} = substr($line_no_id,0,$i-1);}
		}else{
		    $self->{_props}->{_code_no_quotes} .= $char;
		}
	    }
	}
    }
    if (!$comment_found) {$self->{_props}->{_code} =  $line_no_id;}
#	$self->{_props}->{_comment} =~ s/^\s(.*?)\s*$/$1/;
#	$self->{_props}->{_code} =~ s/^\s(.*?)\s*$/$1/;
	$self->{_props}->{_code_no_quotes} =~ s/^\s(.*?)\s*$/$1/;
}

# Getter for the code (excluding comments)
sub Code {
    my $self = shift;
    return $self->{_props}->{_code};
}

# Getter for the comment part of the line
sub comment {
    my $self = shift;
    return $self->{_props}->{_comment};
}

# Getter for the code with no quotes
sub code_no_quotes {
    my $self = shift;
    return $self->{_props}->{_code_no_quotes};
}

# Getter for the module sequence number
sub mod_seq {
    my $self = shift;
    return $self->{_props}->{_mod_seq};
}

# Check if the line is a comment
sub is_comment {
    my $self = shift;
    return ($self->comment && !$self->Code);
}

# Check if the line indicates a RETURN statement
sub is_return {
    my $self = shift; 
    return ($self->code_no_quotes =~ /^\s*RETURN.*/);
}

# Check if the line indicates a GOSUB statement and returns the target
sub is_gosub {
    my $self = shift;
    $self->code_no_quotes =~ /.*GOSUB\W*(([0-9]+)|([A-Z][A-Z0-9]*))/; 
    return $1;
}

# Identifies if a line contains an IF statement
sub is_if {
    my $self = shift;
    return $self->code_no_quotes =~ /^\s*IF/;
}

# Method to extract the GOSUB subroutine this line points to
sub gosub_this {
    my $self = shift;
	$DEBUG=0;
	if ($self->{_props}->{_gosub_this}){return $self->{_props}->{_gosub_this};}
    my $begin_line; $bas_line_id;
    my $mod = $self->{_props}->{_mod};
    my $mod_lines = $mod->lines;
    my $i; my $i; my $_return;
    my $mod_lines_col = $mod_lines->col; my $init_goto_chain_done ;
	my %mod_sub_col = %{$mod->subs->col};

    	$bas_line_id = $self->is_gosub ;
		if ($mod_subs_col->{$bas_line_id}){return $mod_subs_col->{$bas_line_id};} 
							if ($DEBUG){
								print "SUB= " . "\t" ;
								print $mod_lines_col->[$i]->bas_line_id .  "\t" ;
								print $mod_lines_col->[$i]->Code . "\t" ;
								print $mod_lines_col->[$i]->comment . "\n" ; 
							}
		$begin_line = $mod_lines->item($bas_line_id);
		my $sub = Sub->new($mod);
		$i = $begin_line->mod_seq - 1;
		while ($mod_lines_col->[$i]->is_comment){
			$sub->add_line($mod_lines_col->[$i--]);
		}
		$i = $begin_line->mod_seq;# $sub->add_line($mod_lines_col->[$i]);
							if ($DEBUG){print "+j_line = " . "\t" ;
							print $mod_lines_col->[$i]->bas_line_id .  "\t" ;
							print $mod_lines_col->[$i]->Code . "\t" ;
							print $mod_lines_col->[$i]->comment . "\n" ; }

		while (!$_return && $i<= $mod_lines->ubound){
			if ($init_goto_chain_done == undef){
				if ($mod_lines_col->[$i]->is_goto){
					$sub->add_line($mod_lines_col->[$i]);
					$i = $mod_lines_col->[$i]->goto_this->mod_seq;
					next;
				}elsif(!$mod_lines_col->[$i]->comment){
					$init_goto_chain_done = 1;
				}
			}

			if ($mod_lines_col->[$i]->is_return) {$_return = 1;}
			$sub->add_line($mod_lines_col->[$i++]);
							if ($DEBUG){print "/j_line = " . "\t" ;
								print $mod_lines_col->[$i]->bas_line_id .  "\t" ;
								print $mod_lines_col->[$i]->Code . "\t" ;
								print $mod_lines_col->[$i]->comment . "\n" ; 
								}
		}

		$self->{_props}->{_gosub_this} = $sub;
		return $sub;
}

# Getter for the associated module
sub mod {
    my $self = shift;
    return $self->{_props}->{_mod};
}

# Check if the line is a GOTO statement and returns the target
sub is_goto {
    my $self = shift;
    $self->code_no_quotes =~ /^\s*GOTO\s*(([0-9]+)|([A-Z][A-Z0-9]*))/;
    return $1;
}

# Method to add a variable instance to the line
sub add_var_instance {
    my $self=shift;
    my $instance=shift;
    my $instances = $self->{_props}->{_instances};
	$instances->add($instance);
}
	
sub var_instances{
    my $self=shift;
	return $self->{_props}->{_var_instances};
}

# Getter for the variable instances associated with this line
sub var_instances {
    my $self = shift;
    my $mod_lines = $self->mod->lines->col;
	$lines_that_goto_me = Lines->new;
    my $line; 
	foreach $line (@{$mod_lines}){
		if ($line->goto_this eq $self){
			$lines_that_goto_me->add($line);
		}
	}
	return $lines_that_goto_me;
}


# Method to resolve the GOTO target for this line
sub goto_this {
    my $self=shift;
	if (!$self->{_props}->{_goto_this}){
		my $mod = $self->{_props}->{_mod};
		$bas_line_id = $self->is_goto;
		if ($bas_line_id){$self->{_props}->{_goto_this} = $mod->lines->item($bas_line_id)};
	}
	return $self->{_props}->{_goto_this};

}
	
sub vars{
    my $self = shift;
    my $vars = Vars->new($self);
}
sub sub_im_in{
	#Unfinished. Use get_sub_im_in
	if ($self->{_props}->{_sub_im_in} == undef){
		my $self = shift;
		my $mod = $self->{_props}->{_mod};
		my $subs =  $mod->subs;
    	my $subs_col = $subs->col;
		my $mod_seq = $self->{_props}->{_mod_seq};
		while (($key,$sub) = each %{$subs_col}){
			if ($mod_seq <= $sub->lines->ubound && $mod_seq >= $sub->lines->lbound){
				$self->{_props}->{_sub_im_in} = $sub;
			}
		}
	}
	return $self->{_props}->{_sub_im_in};
}


# Method to explicitly set the subroutine this line is part of
sub set_sub_im_in {
    my $self = shift;
    my $sub = shift;
    $self->{_props}->{_sub_im_in} = $sub;
}

# Getter for the subroutine this line is part of
sub get_sub_im_in {
    my $self = shift;
    return $self->{_props}->{_sub_im_in};
}

# Method to extract and return dimension-related code
sub dimention_code {
    my $self = shift;
    if ($self->code_no_quotes =~ /DIM(.*)/){
		return $1;
	}
}
sub non_dimention_code{
    my $self = shift;
    $self->code_no_quotes =~ /(.*)(DIM|)/;
	return $1;
}

1;  # Ensures the module returns true to signify it loaded correctly
