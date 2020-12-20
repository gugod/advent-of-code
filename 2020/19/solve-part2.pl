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

$rules{8} = "42 | 42 8";
$rules{11} = "42 31 | 42 11 31";

my %rounds = ( 8 => 0, 11 => 0 );
my $R = '(?:0)';
while ($R =~ m/[0-9]/) {
    $R =~ s{([0-9]+)}{
        my $n = $1;
        my $r = $rules{$1};

        if ($n eq "8" || $n eq "11") {
            if ($rounds{$n}++ > 5) {
                $r = ""
            }
        }

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
say "Part2: $parsables";
