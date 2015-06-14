#!/usr/bin/perl
package Mod;
use Lines;
use Subs;
use Vars;
sub new {
    my $class = shift;
    my $self = {};
    bless $self, $class; 
    &_init($self,@_);
    return $self;
}
sub _init{
    my $self = shift;
    $self->{_props}->{_path} = shift;
    $self->{_props}->{_mods} = shift;
}
sub load_mod{
    my $self = shift;
    $self->{_props}->{_lines} = Lines->new();
    $self->{_props}->{_lines}->load_mod($self); 
    $self->{_props}->{_subs} = Subs->new;
    $self->{_props}->{_subs}->load_mod($self); 
    $self->{_props}->{_vars} = Vars->new;
    $self->{_props}->{_vars}->load_mod($self);

}
sub path{
    $self = shift;
    return $self->{_props}->{_path};
}

sub subs{
    my $self=shift;
    $self->{_props}->{_subs};
}

sub lines{
    my $self=shift;
    return $self->{_props}->{_lines};
}

sub vars{
    my $self=shift;
    $self->{_props}->{_vars}; 
}

sub dim_lines{
    my $self=shift;
    $self->{$_dim_lines} ;
}

sub item{
    my $self = shift;
    return $self->col
}

sub mods{
    my $self = shift;
    return $self->{_props}->{_mods};
}
1;
