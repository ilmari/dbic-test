#!/usr/bin/env perl
use strict;
use warnings;
use lib 'lib';
use My::Schema;
use Data::Printer;
use SQL::Abstract::Tree;
use 5.18.0;

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

my $rs = $schema->resultset('Main')->search({
    'clan.name' => 'foo',
    'subs.name' => 'bar',
},{
    prefetch => [ 'subs', 'clan' ],
    #order_by => { -asc => 'clan.name' },
})->slice(1,5);

XX $rs;
