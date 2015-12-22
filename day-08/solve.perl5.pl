use v5.20;
sub count_it {
    my ($line) = @_;
    my ($mem,$code) = (0,0);
    $code = length($line);
    my $x = undef;
    for my $i (1..$code-2) {
        my $c = substr($line, $i, 1);
        if (defined($x)) {
            # \\ \" \xNN
            if ($c eq "\\" || $c eq '"') {
                $mem++;
                $x = undef;
            } elsif ($c eq "x") {
                $x = "x";
            } elsif (substr($x,0,1) eq "x" && $c =~ /[0-9a-f]/) {
                $x .= $c;
                if (length($x) == 3) {
                    $mem++;
                    $x = undef;
                }
            } else {
                die "Weird input: $line";
            }
        } elsif ($c eq "\\") {
            $x = "";
        } else {
            $mem++;
            $x = undef;
        }
    }

    return ($mem,$code);
}

my @input;
open my $fh, "<", "input";
while (<$fh>) {
    chomp($_);
    push @input, $_;
}

my $total = 0;
for (@input) {
    my ($mem, $code) = count_it($_);
    $total += $code - $mem;
}
say "Part 1: $total";
