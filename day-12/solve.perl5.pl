use v5.20;
use JSON::PP qw(decode_json);
use Scalar::Util qw(reftype looks_like_number);

open my $fh, "<", "input";
local $/ = undef;
my $input = <$fh>;
my $sum = 0;
while ($input =~ m/(-?[0-9]+)/g) {
    $sum += $1;
}
say "Part 1: $sum";

sub visit {
    my $data = shift;
    my $type = reftype($data);
    if (!$type) {
        if (looks_like_number($data)) {
            return $data;
        }
        return 0;
    }
    if ($type eq 'ARRAY') {
        my $ret = 0;
        for (@$data) {
            $ret += visit($_);
        }
        return $ret;
    } elsif ($type eq 'HASH') {
        my $ret = 0;
        for my $k (keys %$data) {
            if (!reftype($data->{$k})) {
                return 0 if ($data->{$k} eq 'red');
            }
            $ret += visit($data->{$k});
        }
        return $ret;
    } else {
        die "WTF: $type"
    }
}

my $thing = decode_json($input);
my $sum2 = visit($thing);
say "Part 2: $sum2";
