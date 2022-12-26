use v5.36;
use FindBin '$Bin';
use lib $Bin . '/../../perl5/lib';
use AoC;

sub main ( $input = "input" ) {
    my @snafu = map { chomp; Snafu->new($_) } slurp($input);
    say reduce { $a->add($b) } @snafu;
}
main(@ARGV);
exit();

package SnafuDigit {
    use AoC;
    use overload '""' => \&Str;

    sub new ($class, $char) {
        bless \$char, $class;
    }

    sub Str {
        my $self = shift;

        $$self;
    }

    sub equals ($self, $str) {
        $self->Str() eq $str
    }

    sub add ($self, $other) {
        my $a = $self->Str();
        my $b = $other->Str();

        my $carry;
        my $d;

        if ($a eq any('-', '=')) {
            if ($b eq any('-','=')) {
                if ($a eq '-' && $b eq '-') {
                    # -1 + -1 = -2
                    $carry = 0;
                    $d = '=';
                } elsif ($a eq '=' && $b eq '=') {
                    # -2 + -2 = -4 = -5 + 1
                    $carry = '-';
                    $d = 1;
                } else {
                    # -2 + -1 = -1 + -2 = -3 = -5 + 2
                    $carry = '-';
                    $d = 2;
                }
            } else {
                # a is one of ('-','='), b is one of (0,1,2)
                my $_d = $b + ($a eq '-' ? -1 : -2);
                $carry = 0;
                $d =  $_d == -2 ? '=' : $_d == -1 ? '-' : $_d;
            }
        } else {
            if ($b eq any('-','=')) {
                return $other->add($self);
            }
            else {
                # a is one of (0,1,2), b is one of (0,1,2)
                my $_d = $a + $b;
                if ($_d > 2) {
                    $carry = 1;
                    $_d -= 5;
                    $d = $_d == -1 ? '-' : '=';
                }
                else {
                    $carry = 0;
                    $d = $_d;
                }
            }
        }

        die gist([$carry,$d]) unless defined($carry) && defined($d);

        return (SnafuDigit->new("$d"), SnafuDigit->new("$carry"));
    }
}

package Snafu {
    use AoC;
    use overload '""' => \&Str;

    sub new ($class, $str) {
        bless \$str, $class;
    }

    sub Str {
        my $self = shift;
        $$self;
    }

    sub digits ($self) {
        map { SnafuDigit->new($_) } split qr//, reverse($$self)
    }

    sub add ($a, $b) {
        my @aDigits = $a->digits;
        my @bDigits = $b->digits;

        if (0+@aDigits > 0+@bDigits) {
            return $b->add($a);
        }

        my @digits;
        my $carry = SnafuDigit->new("0");
        my $i = -1;
        while (++$i <= $#aDigits) {
            my $ad = $aDigits[$i];
            my $bd = $bDigits[$i];

            my ($d, $carry2) = $aDigits[$i]->add( $bDigits[$i] );
            my ($d2, $carry3) = $d->add($carry);
            push @digits, $d2;

            my ($d3, $carry4) = $carry2->add($carry3);

            die "Too much carry to make sense" unless $carry4->equals(0);
            $carry = $d3;
        }

        while ($i <= $#bDigits) {
            my $bd = $bDigits[$i];
            if ($carry->equals(0)) {
                push @digits, $bd;
            } else {
                my ($d, $carry2) = $bDigits[$i]->add($carry);
                push @digits, $d;
                $carry = $carry2;
            }
            $i++;
        }

        unless ($carry->equals(0)) {
            push @digits, $carry;
        }

        return Snafu->new(join "", reverse(@digits));
    }
}
