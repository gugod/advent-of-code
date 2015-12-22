use v5.20;
sub iter_over_char {
    my ($line, $cb) = @_;
    my ($mem,$code) = (0,0);
    $code = length($line);
    my $x = undef;
    for my $i (1..$code-2) {
        my $c = substr($line, $i, 1);
        if (defined($x)) {
            # \\ \" \xNN
            if ($c eq "\\" || $c eq '"') {
                $cb->($c, "\\".$c);
                $x = undef;
            } elsif ($c eq "x") {
                $x = "x";
            } elsif (substr($x,0,1) eq "x" && $c =~ /[0-9a-f]/) {
                $x .= $c;
                if (length($x) == 3) {
                    $cb->(chr(hex(substr($x,1,2))), "\\".$x);
                    $x = undef;
                }
            } else {
                die "Weird input: $line";
            }
        } elsif ($c eq "\\") {
            $x = "";
        } else {
            $cb->($c, $c);
            $x = undef;
        }
    }

    return ($mem,$code);
}

sub count_it {
    my ($line) = @_;
     my ($mem,$code) = (0,0);
    $code = length($line);
    iter_over_char($line, sub { $mem++ });
    return ($mem, $code);
}

sub encode_it {
    my ($line) = @_;
    my $enc = '"\"';
    iter_over_char($line, sub {
                       my ($c, $orig) = @_;
                       $orig =~ s!\\!\\\\!g;
                       $orig =~ s!"!\\"!g;
                       $enc .= $orig;
                   });
    $enc .= '\""';
    return $enc;
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

$total = 0;
for (@input) {
    my $x = encode_it($_);
    $total += length($x) - length($_);
}
say "Part 2: $total";
