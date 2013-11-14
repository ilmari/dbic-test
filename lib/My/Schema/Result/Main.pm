package My::Schema::Result::Main;
use strict;
use warnings;
use base qw/DBIx::Class::Core/;

__PACKAGE__->table('main');
__PACKAGE__->add_columns(qw/ id name clan_id /);
__PACKAGE__->set_primary_key('id');
__PACKAGE__->belongs_to(clan => 'My::Schema::Result::Clan', 'clan_id');
__PACKAGE__->has_many(subs => 'My::Schema::Result::Sub', 'main_id');

1;
