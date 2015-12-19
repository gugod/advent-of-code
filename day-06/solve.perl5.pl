use v5.20;
my (@instruction,%light,%bright);
open my $fh, "<", "input";
while (<$fh>) {
    next unless /^(turn on|turn off|toggle) (\d+),(\d+) through (\d+),(\d+)/;
    push @instruction, [ $1, $2, $3, $4, $5 ];
}
local $; = ";";
for (@instruction) {
    my @i = @$_;
    for my $c ($i[1] .. $i[3]) {
        for my $r ($i[2] .. $i[4]) {
            if ($i[0] eq "turn on") {
                $light{$c,$r} = 1;
                $bright{$c,$r} += 1;
            }
            elsif ($i[0] eq "turn off") {
                delete $light{$c,$r};
                $bright{$c,$r} -= 1 if $bright{$c,$r} > 0;
            }
            elsif ($i[0] eq "toggle") {
                $bright{$c,$r} += 2;
                if ($light{$c,$r}) {
                    delete $light{$c,$r};
                } else {
                    $light{$c,$r} = 1;
                }
            }
            else {
                die "WTF";
            }
        }
    }
}

say "Got " . scalar(@instruction) . " instructions";
say "Part 1: " . scalar(keys %light);

my $sum = 0;
$sum += $_ for values %bright;
say "Part 2: $sum";
