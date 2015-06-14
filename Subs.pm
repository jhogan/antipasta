package Subs;
use Mod;
use Sub; 
use Lines;
use Line;
sub new{ 
	my $class = shift;
	my $self = {};
	bless $self, $class;
	return $self;
}

sub load_mod{
    my $self = shift;
    my $sub;
    my $mod = $self->{_props}->{_mod} = shift;
    my $mod_lines = $mod->lines;
    my $i; my $j; my $return_found;

	my $mod_lines_col = $mod_lines->col;
	for ($i=0;$i<=$mod_lines->count;$i++){
        $line = $mod_lines_col->[$i];
		if ($line->is_gosub){
			#print "i_line = " . $line->bas_line_id . "\t" .  $line->Code  . "\t" .   $line->comment . "\n"; 
			
			$self->add($line->gosub_this);
		}
	}
}
sub add{
    my $self=shift;
    my $sub = shift;
	$self->{_col}->{$sub->bas_line_id} = $sub;
} 
sub col{
	my $self = shift;
	return $self->{_col};
}
sub item_by_line{
	my $self = shift;
	my $line = shift;
	$line->code_no_quotes =~ /.*GOSUB\W*(([0-9]+)|([A-Z][A-Z0-9]*))/; 
    my $bas_line_id = $1;
    return $self->{_col}->{$bas_line_id};
}

	
1;
