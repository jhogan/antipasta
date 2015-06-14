package Sub;
use Subs;
use Sub;
use Lines;
use Mod;
sub new {
    my $class = shift;
    my $mod = shift;
    my $self = {};
    bless $self, $class; 
    $self->_init($mod);
    return $self;
}
sub _init{
    my $self = shift;
    $self->{_props}->{_mod} = shift;
    $self->{_props}->{_lines} = Lines->new;
}
sub add_line{
    my $self = shift;
    my $line = shift;
    if (!$self->{_props}->{_bas_line_id}) {$self->{_props}->{_bas_line_id} = $line->bas_line_id;}
	$line->set_sub_im_in($self); 
	$self->{_props}->{_lines}->add($line);
    if (!$self->{_props}->{_lines}->count){
		$self->{_props}->{_start_line} = $line;
    }
}


sub subs_i_call{
    my $self = shift;
	if (!$self->{_props}->{_subs_i_call}){
			my $sub; 
			my @simple_col = @{$self->{_props}->{_lines}->simple_col}; 
			my $line;
			my $subs_i_call = Subs->new; my $i;
			foreach $line (@simple_col){ 
				if ($line->is_gosub){
					$sub = $line->gosub_this;
				    $subs_i_call->add($sub);
				}
			}
			$self->{_props}->{_subs_i_call} = $subs_i_call;
			return $subs_i_call;
	}
	return $self->{_props}->{_subs_i_call} ;
}


sub subs_that_call_me{
    my $self = shift;
    my $subs_that_call_me = Subs->new;
    my $mod_subs = $self->{_props}->{_mod}->subs->col;
    my $mod_sub = $self->{_props}->{_mod}->subs->col;
    my $sub;
    foreach $mod_sub (values %{$mod_subs}){
		$subs_i_call = $mod_sub->subs_i_call->col;
    	foreach $sub_i_call (values %{$subs_i_call}){
			if ($sub_i_call eq $self){$subs_that_call_me->add($mod_sub)};
		}
    }	
    return $subs_that_call_me;
}

sub lines{
	$self = shift;
	return $self->{_props}->{_lines};
}
sub bas_line_id{
	my $self = shift;
   	return $self->{_props}->{_bas_line_id};
}
1;



