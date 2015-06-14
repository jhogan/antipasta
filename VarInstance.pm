package VarInstance;

sub new {
   my $class = shift;
   my $self = {};
   bless $self, $class; 
   $self->_init(@_); 
   return $self;
}

sub _init(){
	my $self = shift;
	my $self->{_props}->{_var} = shift;
	my $self->{_props}->{_element1} = shift;
	my $self->{_props}->{_element2} = shift;
	my $self->{_props}->{_offset} = shift;
	my $self->{_props}->{_line} = shift;
	my $self->{_props}->{_mod} = shift;
}

sub var{
    my $self=shift;
	return $self->{_props}->{_var};
}
sub element1{
    my $self=shift;
	return $self->{_props}->{_element1};
}
sub element2{
    my $self=shift;
	return $self->{_props}->{_element2};
}
sub offset{
    my $self=shift;
	return $self->{_props}->{_offset};
}
sub line{
    my $self=shift;
	return $self->{_props}->{_line};
}
sub mod{
    my $self=shift;
	return $self->{_props}->{_mod};
}
1;
