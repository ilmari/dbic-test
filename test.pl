#!/usr/bin/env perl
use strict;
use warnings;
use lib 'lib';
use My::Schema;
use Data::Printer;
use SQL::Abstract::Tree;
use 5.18.0;

# this is just for debug dump
sub XX($) {
    my ($rs) = @_;

    my ($q,@bind) = @{${$rs->as_query}};
    @bind = map { $_->[1] || '0e0' } @bind;
    state $tree = SQL::Abstract::Tree->new({
        profile=>'console',
        fill_in_placeholders => 1,
    });
    say '-'x30;
    say 'Resultset:';
    say $tree->format($q,\@bind);
    say '-'x30;
    say '';
    return $rs;
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

you C<join> instead of C<prefetcH>

=item *

you C<prefetch> only C<clan>

=item *

you remove the C<order_by>

=item *

you remove the C<slice>

=back

=cut

my $rs = $schema->resultset('Main')->search({
    'subs.name' => 'bar',
},{
    prefetch => [ 'subs' ],
    order_by => { -asc => 'clan.name' },
})->slice(1,5);

XX $rs;
