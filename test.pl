#!/usr/bin/env perl
use strict;
use warnings;
use lib 'lib';
use My::Schema;
use Data::Printer;
use SQL::Abstract::Tree;
use Try::Tiny;
use 5.18.0;

BEGIN { say '<html><head><title>DBIC test</title><head><body>' }
END { say '</body></html>' }

# this is just for debug dump
sub XX($$) {
    my ($title,$rs) = @_;

    state $tree = SQL::Abstract::Tree->new({
        profile=>'html',
        fill_in_placeholders => 1,
    });

    say '<hr />';
    say "<h1>$title</h1>";
    say '<h2>resultset:</h2>';

    try {
        my ($q,@bind) = @{${$rs->as_query}};
        @bind = map { $_->[1] || '0e0' } @bind;
        say '<code>'.$tree->format($q,\@bind).'</code>';
    } catch {
        say "<p>could not build query: <pre>$_</pre></p>";
    };

    say '<hr />';
    say '<h2>Running it:</h2>';
    try {
        my @ret = $rs->all;
        say '<p>ok</p>';
    } catch {
        say "<p>could not run it: <pre>$_</pre></p>";
    };
    say '<hr />';
    say '';
}

my $schema = My::Schema->connect('dbi:SQLite:dbname=:memory:','','');
$schema->deploy;

=pod

If you restrict across a has_many, order across a belongs_to,
prefetch the has_many, then slice, DBIC barfs

This works if:

=over 4

=item *

you remove the search criterion

=item *

you C<join> instead of C<prefetch>

=item *

you remove the C<order_by>

=item *

you remove the C<slice>

=back

=cut


my %rs_set = (
    '1. no criterion' => [ {
    },{
        prefetch => 'subs',
        join => 'clan',
        order_by => { -asc => 'clan.name' },
    } ],
    '2. no prefetch' => [ {
        'subs.name' => 'bar',
    },{
        join => ['subs','clan'],
        order_by => { -asc => 'clan.name' },
    } ],
    '3. no order_by' => [ {
        'subs.name' => 'bar',
    },{
        prefetch => 'subs',
        join => 'clan',
    } ],
    '4. all of it' => [ {
        'subs.name' => 'bar',
    },{
        prefetch => 'subs',
        join => 'clan',
        order_by => { -asc => 'clan.name' },
    } ],
    '5. all of it, different prefetch/join' => [ {
        'subs.name' => 'bar',
    },{
        prefetch => 'clan',
        join => 'subs',
        order_by => { -asc => 'clan.name' },
    } ],
);

for my $rs_name (sort keys %rs_set) {
    my $rs = $schema->resultset('Main')->search(@{$rs_set{$rs_name}});

    XX "$rs_name not sliced", $rs;

    my $sliced_rs = $rs->slice(1,5);

    XX "$rs_name sliced", $sliced_rs;
};
