package
    Perl::Critic::Policy::BuiltinFunctions::GrepWithSimpleValue;

# DATE
# VERSION

use warnings;
use strict;
use base 'Perl::Critic::Policy';
use Perl::Critic::Utils qw/:severities is_function_call/;
use Perl::Critic::Utils::PPI qw/is_ppi_constant_element/;

sub supported_parameters { return }
sub default_severity { return $SEVERITY_MEDIUM }
sub default_themes { return qw/core bugs/ }
sub applies_to { return 'PPI::Token::Word' }

my $DESC = q{"grep" with constant value};
my $EXPL = q{Will return all or none of the values};

# based partially on
# Perl::Critic::Policy::BuiltinFunctions::ProhibitComplexMappings

sub violates {
	my ($self, $elem) = @_;
	return if $elem->content() ne 'grep';
	return if !is_function_call($elem);
	my $sib = $elem->snext_sibling();
	return $self->violation('Nothing following "grep"?',
		'It seems there is a lone "grep" in your code?',
		$elem) if !$sib;
	my $arg = $sib;
	if ( $arg->isa('PPI::Structure::List') ) {
		$arg = $arg->schild(0);
		$arg && $arg->isa('PPI::Statement::Expression')
			and $arg = $arg->schild(0);
	}
	if ($arg && $arg->isa('PPI::Structure::Block')) {
		my $stmt = $arg->schild(-1);
		return $self->violation($DESC,$EXPL,$sib)
			if !$stmt
			|| $stmt->isa('PPI::Statement')
			&& (   $stmt->schildren()==1
				|| $stmt->schildren()==2
					&& $stmt->schild(1)->isa('PPI::Token::Structure')
					&& $stmt->schild(1)->content eq ';' )
			&& is_ppi_constant_element($stmt->schild(0));
	}
	elsif ($arg && is_ppi_constant_element($arg))
		{ return $self->violation($DESC,$EXPL,$sib) }
	return;
}

1;
# ABSTRACT: Warn grep with simple value

=head1 SYNOPSIS


=head1 DESCRIPTION

This policy is written by HAUKEX.

A C<grep> with a constant value as the last thing in its block will either
return all or none of the items in the list (depending on whether the value is
true or false). You may have accidentally said C<grep {123}> when you meant
C<grep {$_==123}>, or C<grep {"foo"}> when you meant C<grep {$_ eq "foo"}> or
C<grep {/foo/}>.


=head1 SEE ALSO

L<http://perlmonks.org/?node_id=1196368>
