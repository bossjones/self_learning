#!/usr/bin/perl -w
#use 5.01O; does not work
use strict;

my @names; 

&greet( 'Fred' );
&greet( 'Tobin' );
&greet( 'John' );
&greet( 'Tom' );

sub greet {
    my $who = shift;

    print "Hello $who! ";
    if ( @names ) {
	print "I've names: @names\n";
    }
    else {
	print "You are the first one here\n";
    }
    push @names, $who;
}

