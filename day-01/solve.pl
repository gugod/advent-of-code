use v5.22;
local $/ = undef;
my @todo = split("", scalar(<>));
my %step = ( '(' => 1, ')' => -1 );
my $santa_at = 0;
my $santa_first_visit_to_basement;
for my $i (0..$#todo) {
    $santa_at+= $step{$todo[$i]};
    $santa_first_visit_to_basement //= ($i+1) if $santa_at == -1;
}
say "part 1: $santa_at";
say "part 2: $santa_first_visit_to_basement";




