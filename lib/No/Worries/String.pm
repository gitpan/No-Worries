#+##############################################################################
#                                                                              #
# File: No/Worries/String.pm                                                   #
#                                                                              #
# Description: string handling without worries                                 #
#                                                                              #
#-##############################################################################

#
# module definition
#

package No::Worries::String;
use strict;
use warnings;
our $VERSION  = "0.7";
our $REVISION = sprintf("%d.%02d", q$Revision: 1.4 $ =~ /(\d+)\.(\d+)/);

#
# used modules
#

use No::Worries::Export qw(export_control);
use Params::Validate qw(validate_pos :types);

#
# global variables
#

our(
    @_Map,   # mapping of characters to escaped strings
);

#
# escape a string (quite compact, human friendly but not Perl eval()'able)
#

sub string_escape ($) {
    my($string) = @_;
    my(@list);

    validate_pos(@_, { type => SCALAR });
    foreach my $ord (map(ord($_), split(//, $string))) {
        push(@list, $ord < 256 ? $_Map[$ord] : sprintf("\\x{%04x}", $ord));
    }
    return(join("", @list));
}

#
# remove leading and trailing spaces
#

sub string_trim ($) {
    my($string) = @_;

    validate_pos(@_, { type => SCALAR });
    $string =~ s/^\s+//;
    $string =~ s/\s+$//;
    return($string);
}

#
# module initialization
#

foreach my $ord (0 .. 255) {
    $_Map[$ord] = 32 <= $ord && $ord < 127 ?
        chr($ord) : sprintf("\\x%02x", $ord);
}
$_Map[ord("\t")] = "\\t";
$_Map[ord("\n")] = "\\n";
$_Map[ord("\r")] = "\\r";
$_Map[ord("\e")] = "\\e";
$_Map[ord("\\")] = "\\\\";

#
# export control
#

sub import : method {
    my($pkg, %exported);

    $pkg = shift(@_);
    grep($exported{$_}++, map("string_$_", qw(escape trim)));
    export_control(scalar(caller()), $pkg, \%exported, @_);
}

1;

__DATA__

=head1 NAME

No::Worries::String - string handling without worries

=head1 SYNOPSIS

  use No::Worries::String qw(string_escape string_trim);

  printf("found %s\n", string_escape($data));
  $string = string_trim($input);

=head1 DESCRIPTION

This module eases string handling by providing convenient string
manipulation functions.

=head1 FUNCTIONS

This module provides the following functions (none of them being
exported by default):

=over

=item string_escape(STRING)

return a new string with all potentially non-printable characters
escaped; this includes ASCII control characters, non-7bit ASCII and
Unicode characters

=item string_trim(STRING)

return a new string with leading and trailing spaces removed

=back

=head1 SEE ALSO

L<No::Worries>.

=head1 AUTHOR

Lionel Cons L<http://cern.ch/lionel.cons>

Copyright CERN 2012
