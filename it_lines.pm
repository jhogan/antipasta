#!/usr/bin/perl
use Mods;
use Mod;
use Subs;
use Sub;
use Line;
use Lines;
my $mods = Mods->new("/home/jhogan/forte3");
my $modcol = $mods->col;
$mod = $mods->item("/home/jhogan/forte3/ibb/src/AR/AR.CS.MAIN");
$mod->load;
$lines = $mod->lines;
$lines_col = $lines->col;

for ($i=$lines->lbound;$i<=$lines->ubound;$i++){
	$line = $lines_col->[$i]	;
	print   $line->mod_seq . "\t";
	print   $line->bas_line_id . "\t";
	print   $line->Code . "\t";
	print   $line->comment . "\n";
	if ($line->is_if){
		print "IS_IF: \n";
		print "THEN:" . $line->then . "\n";
	}
}

