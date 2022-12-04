use v5.36;

package AoC::MinHeap::Str {
    use AoC::MinHeap;
    our @ISA = 'AoC::MinHeap';

    sub pop($self) {
        my $stash = $self->__stash;
        return undef if @$stash == 0;
        my $min = $stash->[0];

        $stash->[0] = $stash->[ $#$stash ];
        delete $stash->[ $#$stash ];

        my $i = 0;
        while (2*$i+2 <= $#$stash) {
            my ($j1, $j2) = (2*$i+1, 2*$i+2);
            my $j = $stash->[$j1] lt $stash->[$j2] ? $j1 : $j2;

            last if $stash->[$i] lt $stash->[$j];

            ($stash->[$j], $stash->[$i]) = ($stash->[$i], $stash->[$j]);
            $i = $j;
        }

        return $min;
    }

    sub push($self, @vals) {
        my $stash = $self->__stash;
        for my $v (@vals) {
            CORE::push @$stash, $v;
            my $j = $#$stash;
            my $i = int(($j - 1) / 2);
            while ($j > 0 && ($stash->[$j] lt $stash->[$i])) {
                ($stash->[$j], $stash->[$i]) = ($stash->[$i], $stash->[$j]);
                $j = $i;
                $i = int $j / 2;
            }
        }
    }
};

1;
