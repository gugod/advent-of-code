use v5.36;
package AoC::Util {
    use Exporter 'import';

    our @EXPORT_OK = qw(count);

    sub count :prototype(&@) {
        my $predicate = shift;
        my $count = 0;
        for (@_) {
            $count++ if $predicate->($_);
        }
        return $count;
    }

};
1;
