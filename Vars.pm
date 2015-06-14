package Vars;
use Var;
use Generic;

sub new {
   my $class = shift;
   my $self = {};
   bless $self, $class; 
   return $self;
}


sub load_mod {
    my $self = shift;
    my $mod =  shift; 
    my $dim_lines = $mod->lines->dim_lines; my $line;
    my $dim_code; my @dim_var; my $dim_var;
	my $var;
    my $i = 0;
    #GET NUM VARS
	foreach $line (@{$dim_lines}){
		my $precision;
		if ($dim_code = $line->dimention_code){
			@dim_vars = split / *, */, $dim_code;
			foreach $dim_var (@dim_vars){
				if ($dim_var =~ m/([1-4])%/){
					$precision = $1;
					next;
				}
				if ($precision == undef){$precision = 2};
				$dim_var =~ m/(\w+\$?)(\[ *(\d+)( *, *(\d+))?)?/;
				$name = $1; $element1 = $2; $ubound2 = $4;
				$var=Var->new($name, $precision, $ubound1, $ubound2, $line, $mod); #name, precision, dimention (ubound), line (dimentioned on), mod.
				$self->add($var);
			}
		}	
	}
	VarInstances->load_mod($mod);
}
				
sub add{
	my $self = shift;
	my $var = shift;
	my $name = $var->name;
	#if ($self->{_col}->{$name}){#print warning}
	$self->{_col}->{$name} = $var;
}
sub col{
	my $self = shift;
	return $self->{_col}; 
}

sub item{
	my $self = shift;
	my $name = shift;
	return $self->col->{$name};
}
1;
