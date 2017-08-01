package Perl::Critic::PolicyBundle::PERLANCAR;
package # hide from PAUSE
    Perl::Critic::Policy::Variables::ProhibitFatCommaInDeclaration;

# DATE
# VERSION

use warnings;
use strict;
use base 'Perl::Critic::Policy';
use Perl::Critic::Utils ':severities';
use List::Util 'first';

sub supported_parameters { return }
sub default_severity { return $SEVERITY_HIGH }
sub default_themes { return qw/core bugs/ }
sub applies_to { return 'PPI::Statement::Variable' }

sub violates {
    my ($self, $elem) = @_;
    my $found = first { $_->isa('PPI::Token::Operator') } $elem->children;
    if ($found && $found->content eq '=>') {
		return $self->violation('Fat comma used in declaration',
			'You probably meant "=" instead of "=>"', $found);
    }
    return;
}

1;
# ABSTRACT: Prohibit fat comma in declaration

=for Pod::Coverage ^(.+)$

=head1 SYNOPSIS

=head1 DESCRIPTION

This policy is written by HAUKEX.


=head1 SEE ALSO

L<http://perlmonks.org/?node_id=1180082>
