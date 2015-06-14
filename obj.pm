package pkg;

sub new {
    my $class = shift;
    my $self = {};
    bless $self, $class; 
    &_init($self,$_[0]);
    return $self;
}
sub _init{
}
