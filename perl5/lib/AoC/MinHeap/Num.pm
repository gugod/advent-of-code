use v5.36;

package AoC::MinHeap::Num {
    use AoC::MinHeap;
    our @ISA = 'AoC::MinHeap';

    sub min ($self) {
        my $stash = $self->__stash;
        return undef if @$stash == 0;
        return $stash->[0];
    }

    sub pop($self) {
        my $stash = $self->__stash;
        return undef if @$stash == 0;
        my $min = $stash->[0];

        $stash->[0] = $stash->[ $#$stash ];
        delete $stash->[ $#$stash ];

        my $i = 0;
        while (2*$i+1 <= $#$stash) {
            for my $j (2*$i, 2*$i+1) {
                if ($stash->[$j] < $stash->[$i]) {
                    ($stash->[$j], $stash->[$i]) = ($stash->[$i], $stash->[$j]);
                    $i = $j;
                    last;
                }
            }
        }

        return $min;
    }

    sub push($self, @vals) {
        my $stash = $self->__stash;
        for my $v (@vals) {
            CORE::push @$stash, $v;
            my $j = $#$stash;
            my $i = int $j / 2;
            while ($j > 0 && ($stash->[$j] < $stash->[$i])) {
                ($stash->[$j], $stash->[$i]) = ($stash->[$i], $stash->[$j]);
                $j = $i;
                $i = int $j / 2;
            }
        }
    }
};

1;
__END__

=head1 Examples

    my $heap = AoC::MeanHeap::Num->new( size => 10 );

    # Add new values
    $heap->push($n);
    $heap->push(@nums);

    # Get the minimum value.
    $heap->min();

    # Remove the minimum value, and re-adjust the heap.
    my $n = $heap->pop();
