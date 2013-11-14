package My::Schema::Result::Clan;
use strict;
use warnings;
use base qw/DBIx::Class::Core/;

__PACKAGE__->table('clan');
__PACKAGE__->add_columns(qw/ id name /);
__PACKAGE__->set_primary_key('id');
__PACKAGE__->has_many(mains => 'My::Schema::Result::Main', 'clan_id');

1;
