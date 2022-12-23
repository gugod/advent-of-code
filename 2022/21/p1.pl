use v5.36;
use FindBin '$Bin';
use lib $Bin . '/../../perl5/lib';
use AoC;

main(@ARGV);
exit;

sub main ( $input = "input" ) {
    my @lines = map {[comb qr/ [a-z]+ | [\+\-\*\/] | [0-9]+ /x, $_]} slurp($input);

    my $code = "package Monkey {";
    for my $x ( @lines ) {
        my ($name, @body) = @$x;
        if (@body == 1) {
            $code .= "  sub $name { " . $body[0] . " }\n";
        } else {
            $code .= "  sub $name { " . $body[0] . "() " . $body[1] . " " . $body[2] . "() }\n";
        }
    }

    $code .= "}";
    eval $code;

    say Monkey::root();
}
