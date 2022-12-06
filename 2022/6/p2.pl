use v5.36;
use File::Slurp qw(slurp);
use List::Util qw(uniq);
my $in = slurp("input");
my $i = my $len = 14;
while ($i < length $in) {
    last if $len == scalar uniq split "", substr $in, $i - $len, $len;
    $i++
}
say $i;
