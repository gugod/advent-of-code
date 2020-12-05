use v5.20;

my $ord_a = ord("a");
my $ord_i = ord("i");
my $ord_o = ord("o");
my $ord_l = ord("l");
sub inc {
    my ($in) = @_;
    if ($in =~ m{\A (.*?) ([iol]) (.*) \z}x) {
        my $p = $2; $p =~ tr/iol/jpm/;
        my $o = $1 . $p . (("a")x(length($3)));
        return $o;
    }

    $in =~ tr/iol/jpm/;
    my @o;
    my @c = reverse(map { ord($_) - $ord_a } split "", $in);
    my $carry = 1;
    my $i = 0;
    while ($i < @c) {
        my $d = $c[$i++] + $carry--;
        if ($d > 25) {
            $d = $d - 26;
            $carry = 1;
        } else {
            $carry = 0;
        }
        if ($d == $ord_i || $d == $ord_o || $d == $ord_l) {
            $carry++;
            $i--;
        } else {
            push @o, $d;
        }
    }
    return join("", reverse(map { chr($_ + $ord_a) } @o));
}

sub good_password {
    my ($s) = @_;
    return 0 if $s =~ /[iol]/;
    return 0 unless $s =~ /(.)\1.*(.)\2/;

    my @c = map { ord($_) - $ord_a } split "", $s;
    for (0..$#c-2) {
        return 1 if 1 == ($c[$_+1] - $c[$_]) && 1 == ( $c[$_+2] - $c[$_+1]);
    }
    return 0;
}

open my $fh, "<", "input";
local $/ = undef;
my $input = <$fh>;

my $output = inc($input);
while (!good_password($output)) {
    $output = inc($output);
}
say "part 1: $output";

$output = inc($output);
while (!good_password($output)) {
    $output = inc($output);
}
say "part 2: $output";

