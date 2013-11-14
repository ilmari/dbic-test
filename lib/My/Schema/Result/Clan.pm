package My::Schema::Result::Clan;
use strict;
use warnings;
use base qw/DBIx::Class::Core/;

__PACKAGE__->table('clan');
__PACKAGE__->add_columns(qw/ id name place_id /);
__PACKAGE__->set_primary_key('id');
__PACKAGE__->has_many(mains => 'My::Schema::Result::Main', 'clan_id');
__PACKAGE__->has_many(widgets => 'My::Schema::Result::Widget', 'clan_id');
__PACKAGE__->belongs_to(place => 'My::Schema::Result::Place', 'place_id');

1;
