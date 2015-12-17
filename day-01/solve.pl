use v5.22;
open my $fh, "<", "input";
local $/ = undef;
my $input = <$fh>;
my %step = ( '(' => 1, ')' => -1 );
my $santa_at = 0;
my $santa_first_visit_to_basement;
for my $i (1..length($input)) {
    my $c = substr($input,$i-1,1);
    $santa_at+= $step{$c};
    $santa_first_visit_to_basement //= ($i+1) if $santa_at == -1;
}
say "part 1: $santa_at";
say "part 2: $santa_first_visit_to_basement";
