use v5.36;
package AoC::Util {
    use Exporter 'import';

    our @EXPORT_OK = qw(count rotor);

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
};
1;
