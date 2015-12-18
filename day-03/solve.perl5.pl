use v5.20;
open my $fh, "<", "input";
local $/ = undef;
my $input = <$fh>;

local $; = ";";
my @santa_at = (0,0);
my %santa_been; $santa_been{0,0} = 1;
my %move = ( '^' => [0,1], 'v' => [0,-1], '>' => [1,0], '<' => [-1,0] );
for my $i (0 .. length($input)-1) {
    my $c = substr($input, $i, 1);
    my $d = $move{$c} or next;
    $santa_at[0] += $d->[0];
    $santa_at[1] += $d->[1];
    $santa_been{$santa_at[0], $santa_at[1]} += 1;
}
say "Part 1: " . scalar keys %santa_been;

@santa_at = (0,0);
my @robot_santa_at = (0,0);
%santa_been = (); $santa_been{0,0} = 1;
for my $i (0 .. length($input)-1) {
    my $c = substr($input, $i, 1);
    my $d = $move{$c} or next;
    if ($i % 2 == 0) {
        $santa_at[0] += $d->[0];
        $santa_at[1] += $d->[1];        
        $santa_been{$santa_at[0], $santa_at[1]} += 1;
    } else {
        $robot_santa_at[0] += $d->[0];
        $robot_santa_at[1] += $d->[1];
        $santa_been{$robot_santa_at[0], $robot_santa_at[1]} += 1;
    }
}
say "Part 2: " . scalar keys %santa_been;
