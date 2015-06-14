#!/usr/bin/perl
package player;
use Ball;
use bat;
my $bat = bat->new;
my $ball = Ball->new;
$bat->your_ball($ball);
1;
