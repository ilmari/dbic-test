package My::Schema::Result::Widget;
use strict;
use warnings;
use base qw/DBIx::Class::Core/;

__PACKAGE__->table('widget');
__PACKAGE__->add_columns(qw/ id clan_id name /);
__PACKAGE__->set_primary_key('id');
__PACKAGE__->belongs_to(clan => 'My::Schema::Result::Clan', 'clan_id');

1;
