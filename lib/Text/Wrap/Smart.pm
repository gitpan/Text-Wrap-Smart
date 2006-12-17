package Text::Wrap::Smart;

use strict;
use warnings;
use base qw(Exporter);

use Math::BigFloat;

our ($VERSION, @EXPORT_OK);

$VERSION = '0.2';
@EXPORT_OK = qw(wrap_smart);

sub wrap_smart {
    my ($text, $conf) = @_;
    die "No text defined!\n" unless $text;

    my $msg_size = $conf->{max_msg_size} || 160;
    my $no_split = $conf->{no_split};
    my @strings;

    if (!$no_split) {
        my ($i, $length_eval);

        my $length = length($text);
        $length_eval = $length;

        do {
            $length_eval -= $msg_size;
            $i++;
        } while ($length_eval > 0);

        my $x = Math::BigFloat->new($length / $i);
        my $average = $x->bceil();

        for ($i = 0; $i < $length; $i += $average) {
            my $string = substr($text, $i, $average);
            push @strings, $string;
        }
    } else {
        my $start = 0;
        while ($start < (length($text)-1)) {
            my $pos = rindex($text, ' ', $msg_size);
            $pos = length($text) if $pos == -1;
            my $str = substr($text, $start, $pos);
            my $pos_size = $start+$pos+1;
            my $length = 0;
            if ($pos_size > length($text)) {
                $pos_size = length($text);
                $length = 0;
            } else {
                $length = length($text) - $pos_size;
            }
            $start += $pos_size; 
            push @strings, $str;
       }
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
             no_split => 1,
             max_msg_size => 160,
            );

 @chunks = wrap_smart($text, \%options);

=head1 DESCRIPTION

C<Text::Wrap::Smart> was primarly developed to split an overly
long SMS message into chunks of equal size. The distribution's
C<wrap_smart()> may nevertheless be used for other purposes.

=head1 FUNCTIONS

=head2 wrap_smart

 @chunks = wrap_smart($text, \%options);

C<%options> may contain the C<no_split> option indicating that
words shall not be broken up. C<max_msg_size> sets the character
length boundary for each chunk emitted.

=head1 SEE ALSO

L<Text::Wrap>

=head1 AUTHOR

Steven Schubiger <schubiger@cpan.org>

=head1 LICENSE

This program is free software; you may redistribute it and/or 
modify it under the same terms as Perl itself.

See L<http://www.perl.com/perl/misc/Artistic.html>

=cut
