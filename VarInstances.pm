package VarInstances;
use Generic;
use VarInstance;

sub new {
   my $class = shift;
   my $self = {};
   bless $self, $class; 
   return $self;
}

sub load_mod{
	$self = shift;
    $self->{_props}->{_mod} = $mod = shift;
    my $lines = $mod->lines->col; my $line;
	my $before_var; my $name; my $element1; my $element2;
	my $offset;
    my $mod_vars = $mod->vars->col;
    my $var;
    my $var_instance;
	foreach $line (@{$lines}){
		if (!$line->dimention_code){
			while ($line->code_no_quotes =~ m/^(.*)([A-Z]\w*\$?)(\[ *(\d+)( *, *(\d+))?)?/g){
				$before_var = $1; $name = $2; $element1 = $4; $element2 = $6;
				if (Generic->I_quote($before_var)){next;}
				$offset = $-[2];
				if (!Generic->is_keyword($name)){
					if ($var = $mod_vars->{$name}){#if var has been found
						if (!$var->explicitly_dimentioned && $var->ubound1 < $element1){$var->set_ubound1($element1);}
						if (!$var->explicitly_dimentioned && $var->ubound2 < $element2){$var->set_ubound2($element2);}
					}else{
						$var = Var->new($name, 2, $element1, $element2, 0, $mod);
						$mod->vars->add($var);
					}
					$var_instance = VarInstance->new($var,$element1, $element2, $offset, $line, $mod);
					$var->add_instance($var_instance);	
					$line->add_var_instance($var_instance);	
				}
			}
		}
	}
}
	
sub add{
    my $self = shift;
    my $instance = shift;
	push @{$self->col}, $instance;
}
sub col{
    my $self = shift;
	return $self->{_col};
}
1;
