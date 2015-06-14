#!/usr/bin/perl
use Mods;
use Mod;
use Subs;
use Sub;
my $sub_that_call_me;
my $mods = Mods->new("/home/jhogan/forte3");
my $modcol = $mods->col;
$mod = $mods->item("/home/jhogan/forte3/ibb/src/OE/OE.PAYREFUND");
$mod->load_mod;
$subs = $mod->subs;
$subs_col = $subs->col;
%subs_col = %{$subs->col};
goto skipSub;
while (($key,$sub) = each %{$subs_col}){
    print "ID:" . $sub->bas_line_id  . "\n";
    @simple_col = @{$sub->lines->simple_col};
    $lines_count = $sub->lines->count;
    foreach $line (@simple_col){
		print   $line->bas_line_id . "\t";
		print   $line->Code . "\t";
		print   $line->comment . "\n";
	}
    
}
my $subs_i_call;
my $subs_i_call_col;
foreach $sub (values %subs_col){
	#$sub = $subs_col{$sub_key};
    print "Sub: " . $sub->bas_line_id  . "\n";
    $subs_i_call = $sub->subs_i_call;
    $subs_i_call_col = $sub->subs_i_call->col;
	
	foreach $sub_i_call (values %{$subs_i_call_col}){
   		print "--calls: " . $sub_i_call->bas_line_id ."\n";
	}
    $subs_that_call_me = $sub->subs_that_call_me->col;
	foreach $sub_that_call_me (values %{$subs_that_call_me}){
   		print "--is called by: " . $sub_that_call_me->bas_line_id ."\n";
	}
}
skipSub:
$lines_col = $mod->lines->col;
foreach $line (@{$lines_col}){
	$lines_that_goto_me = $line->lines_that_goto_me->simple_col;
	foreach $line_that_goto_me (@{$lines_that_goto_me}){
		print $line->full_line . "\n";
		print "\tLines that goto me: " . $line_that_goto_me->full_line . "\n";
			$sub_im_in = $line->get_sub_im_in;
			if ($sub_im_in){print "\t In Gosub:" . $sub_im_in->bas_line_id . "\n";}
	}
}
