use v5.20;

sub enc {
    my ($in) = @_;
    my $out = "";
    my $l = 1;
    my $c = substr($in,0,1);
    for (1..length($in)-1) {
        my $d = substr($in, $_, 1);
        if ($d eq $c) {
            $l++;
        } else {
            $out .= $l . $c;
            $l = 1;
            $c = $d;
        }
    }
    $out .= $l . $c;
    return $out;
}

open my $fh, "<", "input";
local $/ = undef;
my $input = <$fh>;
my $output = $input;
for (1..40) {
    $output = enc($output);
}
say "Part 1: " . length($output);

for (1..10) {
    $output = enc($output);
}
say "Part 2: " . length($output);
