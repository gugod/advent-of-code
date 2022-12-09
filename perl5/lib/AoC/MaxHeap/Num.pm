use v5.36;

package AoC::MaxHeap::Num {
    use AoC::MaxHeap;
    our @ISA = 'AoC::MaxHeap';

    sub pop($self) {
        my $stash = $self->__stash;
        return undef if @$stash == 0;
        my $min = $stash->[0];

        $stash->[0] = $stash->[ $#$stash ];
        delete $stash->[ $#$stash ];

        my $i = 0;
        while (2*$i+1 <= $#$stash) {
            my ($j1, $j2) = (2*$i+1, 2*$i+2);
            my $j = ($j2 <= $#$stash && ($stash->[$j2] > $stash->[$j1])) ? $j2 : $j1;
            last if $stash->[$i] > $stash->[$j];
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
            while ($j > 0) {
                my $i = int(($j - 1) / 2);
                last if $stash->[$i] > $stash->[$j];
                ($stash->[$j], $stash->[$i]) = ($stash->[$i], $stash->[$j]);
                $j = $i;
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
