package Text::Wrap::Smart;

use strict;
use warnings;
use base qw(Exporter);

use Math::BigFloat;

our ($VERSION, @EXPORT_OK);

$VERSION = '0.1';
@EXPORT_OK = qw(wrap_smart);

sub wrap_smart {
    my ($text, $conf) = @_;
    die "No text defined!\n" unless $text;

    my $msg_size = $conf->{max_msg_size} || 160;
    my ($i, $length_eval);

    my $length = length($text);
    $length_eval = $length;

    do {
        $length_eval -= $msg_size;
        $i++;
    } while ($length_eval > 0);

    my $x = Math::BigFloat->new($length / $i);
    my $average = $x->bceil();

    my @strings;

    for ($i = 0; $i < $length; $i += $average) {
        my $string = substr($text, $i, $average);
        push @strings, $string;
    }

    return @strings;
}

1;
__END__

=head1 NAME

Text::Wrap::Smart - Wrap text into chunks of equal length

=head1 SYNOPSIS

 use Text::Wrap::Smart qw(wrap_smart);

 $text = .. # random content & length
 
 %options = (
             max_msg_size => 160,
	    );

 @chunks = wrap_smart($text, \%options);

=head1 DESCRIPTION

C<Text::Wrap::Smart> was primarly developed to split an overly
long SMS message into chunks of equal size. The distribution's
C<wrap_smart()> may nevertheless be used for other purposes.

=head1 FUNCTIONS

=head2 wrap_smart

See section synopsis.

=head1 SEE ALSO

L<Text::Wrap>

=head1 AUTHOR

Steven Schubiger <schubiger@cpan.org>

=head1 LICENSE

This program is free software; you may redistribute it and/or 
modify it under the same terms as Perl itself.

See L<http://www.perl.com/perl/misc/Artistic.html>	    

=cut
