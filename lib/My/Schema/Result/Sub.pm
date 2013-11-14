package My::Schema::Result::Sub;
use strict;
use warnings;
use base qw/DBIx::Class::Core/;

__PACKAGE__->table('subs');
__PACKAGE__->add_columns(qw/ id main_id name /);
__PACKAGE__->set_primary_key('id');
__PACKAGE__->belongs_to(main => 'My::Schema::Result::Main', 'main_id');

1;
