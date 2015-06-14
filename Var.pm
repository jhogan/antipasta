#!/usr/bin/perl
package Var;
use Lines;
use Subs;
use Line;
use Sub;
use Mod;
use Var;
sub new {
    my $class = shift;
    my $self = {};
    bless $self, $class; 
	$self->_init(@_);
    return $self;
}
sub _init{
    my $self = shift;
    $self->{_props}->{_name} = shift;
    $self->{_props}->{_precision} = shift;
    $self->{_props}->{_ubound1} = shift;
    $self->{_props}->{_ubound2} = shift;
    $self->{_props}->{_dim_line} = shift;
    $self->{_props}->{_mod} = shift;
    $self->{_props}->{_instances} = VarInstances->new();
}

sub name{
    my $self = shift;
    return $self->{_props}->{_name};
}
sub precision{
    my $self = shift;
	if ($self->is_num){
    	return $self->{_props}->{_precision};
	}else{
		return 0;
	}
}
sub ubound1{
    my $self = shift;
    return $self->{_props}->{_ubound1};
}
sub set_ubound{
    my $self = shift;
    my $ubound = shift;
    $self->{_props}->{_ubound1} = $ubound;
}
sub ubound2{
    my $self = shift;
    return $self->{_props}->{_ubound2};
}
sub set_ubound2{
    my $self = shift;
    my $ubound = shift;
    $self->{_props}->{_ubound2} = $ubound;
}
sub is_string{
    my $self = shift;
    return $self->{_props}->{_name} =~ /\$$/ ;
}
sub is_num{
    my $self = shift;
    return !$self->is_string;
}
sub explicitly_dimentioned{
    my $self = shift;
    return $self->dim_line;
}
sub dim_line{
    my $self = shift;
    return $self->line;
}
	
sub instances{
    my $self = shift;
	return $self->{_props}->{_instances};
}

#sub subs_im_in {
#    my $self = shift;
#    my $subs = $self->{_mod}->subs;
#    my $sub;
#    my $subs_im_in;
#    my $lines;
#    my $line;
#    my $_name = $self->{_name};
#    foreach $sub ($subs){
#		my $sub_lines = $sub->lines;
#		foreach $line ($sub_lines){
#			if ($line->Code =~ /$_name/){
#			$subs_im_in->add($sub);
#			}
#		}
#    }
#    return $subs_im_in;
#}
#sub lines_im_in {
#    my $self = shift;
#    my $lines = $self->{_mod}->lines;
#    my $line;
#    my $lines_im_in;
#    my $_name = $self->{_name};
#    foreach $line ($lines){
#	my $code = $line->code
#	if ($code =~ /$_name/){
#	    $lines_im_in->add($line);
#	}
#    }
#    return $lines_im_in;
#}
#sub lines_im_assigned_in{
#    my $self = shift;
#    my $lines_im_assigned_in = Lines->new ;
#    my $line;
#    my $lines_im_in = $lines_im_in($self);
#    my $_name = $self->{_name};
#    foreach $line ($lines_im_in){
#	if ($line->if && $line->then){
#	    my $code = $line->then;
#	    if $code =~ /$_name\W=/{
#		$lines_im_in->add($line);
#	    }
#    }
#    return $lines_im_assigned_in;
#}
#sub lines_i_assign_in{
#    my $self = shift;
#    my $lines_i_assign_in = Lines->new; 
#    my $line;
#    my $lines_im_in = $lines_im_in($self);
#    my $_name = $self->{_name};
#    foreach $line ($lines_im_in){
#	if ($line->if && $line->then){
#	my $code = $line->then;
#	    if $code =~ /=\W$_name/{
#		$lines_i_assign_in->add($line);
#	    }
#	}
#    }
#    return $lines_i_assign_in;
#}
#
#sub cur_val{
#    my $self = shift;
#    my $line = shift;
#    if !($line){$line =	self->line_im_in;}
#    my $lines = Lines->new;
#    my @vals_held;
#    my sub;
#    my ordinal;
#    if ($line->sub_im_in){
#	for (i=1,i<=1,i++){
#	    if (i==0){
#		    $self->_line_scan($line->sub_im_in->lines,$line->mod_order,-1,i);
#	    }elseif (i==1){
#		my $subs = $self{_mod}->subs;
#		foreach $sub ($subs){
#		    $self->_line_scan($sub->lines,$lines[0]->mod_order,1,i);
#		}
#	    }
#	}
#    }else{
#	$self->_line_scan($self{_mod}->lines, $line->mod_order,-1,3);
#    }
#}
#
#sub _line_scan{
#    my $self = shift;
#    my $lines = shift;
#    my $i = shift;
#    my $step = shift;
#    my $level = shift;
#    #$goto_depth is lexical
#    #$prev_ass_lines is lexical
#    #var_distance lexical
#    while ($i>0=){
#	if ($lines[i]->is_let){
#	    if (ref($line->assigner)="Var"){
#		if ($level = 0) {
#		    $prev_ass_lines[$goto_dept, $var_distance, $level,  $count++] = $line;
#		$var_distance++;
#	       	$lines[i]->assigner->cur_val($lines[i]); 
#		$var_distance--;
#	    }else{
#		return \$prev_ass_lines;
#	    }
#	}elseif($lines = $line->lines_that_goto_me[0]){
#	    foreach $line (@lines){
#		$goto_depth++; $self->cur_val($line->goto_this->cur_val($line));
#	       	$goto_depth--;
#	    }
#	}
#	i += step;
#	($level == 2 && $lines[i]->gosub_this = $self->{sub_im_in}) ? last; #quit if gosub points to the current sub
#	($level == 1 && $lines[i]->sub_im_in->start_sub = $line[i]) ? last
#	($level == 3 && $lines[i]->is_return ? last; 
#    }
#}
sub add_instance{
    my $self = shift;
    my $instance = shift;
    my $instances = $self->instances;
	$instances->add($instance);
}
1;
