use v5.36;
use strict;
use warnings;
use builtin ();
use feature ':5.36';

package AoC {
    use List::AllUtils qw( minmax );
    use File::Slurp ();
    use JSON::PP qw( encode_json decode_json );

    use Exporter ();
    our @EXPORT = qw<
        count rotor windowed chunked chars parse_2d_map_of_chars
        gist comb minToMax slip VeryLargeNum ArrayRef
        hashkeys arrayindices
    >;

    use constant VeryLargeNum => 2**62;

    sub import {
        my $caller = shift;
        strict->import;
        warnings->import;
        feature->import(":5.36");

        # All new builtin functions
        warnings->unimport('experimental::builtin');
        builtin->import(
            qw(
                  true false is_bool
                  weaken unweaken is_weak
                  blessed refaddr reftype
                  created_as_string created_as_number
                  ceil floor
                  trim
          )
        );

        # Hack: Tweak ExportLevel to make Exporter::import() inject
        # those symbols, not into here, but into the caller package.
        do {
            local $Exporter::ExportLevel = 2;
            List::AllUtils->import( @List::AllUtils::EXPORT_OK );
            File::Slurp->import(qw(slurp));
            JSON::PP->import(qw(encode_json decode_json));
        };
        do {
            local $Exporter::ExportLevel = 1;
            Exporter::import(__PACKAGE__, @EXPORT);
        };
    }

    sub ArrayRef (@things) {
        \@things
    }

    sub count :prototype(&@) {
        my $predicate = shift;
        my $count = 0;
        for (@_) {
            $count++ if $predicate->($_);
        }
        return $count;
    }

    sub rotor ( $size = 1, $skip = 0, @xs ) {
        my @ys;
        my $end = $size - 1;
        while ($end < @xs) {
            push @ys, [ @xs[ ($end - $size + 1) .. $end ] ];
            $end += $size + $skip;
        }
        return @ys;
    }

    sub windowed ( $size, @xs ) {
        rotor $size => -1 * ($size-1), @xs
    }

    sub chunked ( $size, @xs ) {
        rotor $size => 0, @xs
    }

    sub chars ( $s ) {
        wantarray ? split("", $s) : length($s);
    }

    sub parse_2d_map_of_chars ($s) {
        map { [split ""] } split "\n", $s
    }

    sub gist {
        join " ", map { ref($_) ? encode_json($_) : defined($_) ? $_ : "(undef)" } @_
    }

    sub comb ( $pattern, $s ) {
        $s =~ m/($pattern)/g;
    }

    sub minToMax {
        my ($min, $max) = minmax(@_);
        $min ... $max
    }

    sub slip :prototype($) ( $x ) {
        return @$x if ref($x) eq 'ARRAY';
        return %$x if ref($x) eq 'HASH';
        return $x;
    }

    sub hashkeys ( $h ) { keys %$h }
    sub arrayindices ( $a ) { 0..$#$a }
};

1;
