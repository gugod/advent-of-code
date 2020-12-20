use v5.30;
use Data::Dumper;
use IO::All;

my ($rules, $messages) = split "\n\n", io("input")->all;

my %rules;
for my $r (split "\n", $rules) {
    my ($rnum, $rbody) = split ": ", $r;
    if ($rbody eq '"a"') {
        $rbody = "a";
    } elsif ($rbody eq '"b"') {
        $rbody = "b";
    }
    $rules{$rnum} = $rbody;
}

my $R = '(?:0)';
while ($R =~ m/[0-9]/) {
    $R =~ s{([0-9]+)}{
        my $r = $rules{$1};
        if ($r =~ /\|/) {
            "(?:$r)"
        } else {
            $r
        }
    }e;
}

# eyecandy or anti-eyecandy. It's hard to tell.
$R =~ s/ //g;

say "(just take a look at this...):\n$R";

my $parsables = 0;
for my $m (split "\n", $messages) {
    if ($m =~ /\A $R \z/x) {
        $parsables++;
    }
}
say "Part1: $parsables";
