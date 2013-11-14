package My::Schema::Result::Place;
use strict;
use warnings;
use base qw/DBIx::Class::Core/;

__PACKAGE__->table('place');
__PACKAGE__->add_columns(qw/ id name /);
__PACKAGE__->set_primary_key('id');
__PACKAGE__->has_many(clans => 'My::Schema::Result::Clan', 'place_id');

1;
