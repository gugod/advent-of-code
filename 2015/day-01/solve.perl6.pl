#!perl6
use v6;

my $input = open("input").lines[0];

my %step := { '(' => 1, ')' => -1 };
my $santa_at = 0;
my $santa_first_visit_to_basement;
for 1..$input.chars -> $i {
    my $c = $input.substr($i-1,1);
    $santa_at += %step{$c};
    $santa_first_visit_to_basement //= $i if $santa_at == -1;
}

say "part 1: $santa_at";
say "part 2: $santa_first_visit_to_basement";
