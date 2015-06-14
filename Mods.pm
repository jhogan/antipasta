package Mods;
use Mod;

sub new {
    my $class = shift;
    my $FORTE3 = shift;
    my $self = {};
    bless $self, $class; 
    $self->load($FORTE3);
    return $self;
}

sub load{
    my $self = shift;
    $FORTE3 = shift;
    my $mod;
    chdir $FORTE3;
    my @mods = `find -type f |egrep -vi '(CVS|MAKEFILE)' |more`;
    foreach $mod (@mods){
	$mod = $FORTE3 . substr($mod,1);
	chomp($mod);
	$self->{_col}->{$mod} = Mod->new($mod,$self);
    }	
}
sub col{
    my $self = shift;
    return $self->{_col};
}
sub item{
    my $self = shift;
    my $mod = shift;
    $modcol = $self->{_col};
    return $modcol->{$mod};
}
1;
