package pkg;
use pkgs;

sub new {
   my $class = shift;
   my $self = {};
   bless $self, $class; 
   $self->_load(@_);
   return $self;
}
