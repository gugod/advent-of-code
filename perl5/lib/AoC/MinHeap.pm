use v5.36;

package AoC::MinHeap {
    use Scalar::Util qw( looks_like_number );

    sub new ($class, @args) {
        my $self = bless {
            __stash => [],
            compare => sub ($p, $q) { ... },
            @args
        }, $class;

        return $self;
    }

    sub size ($self) { scalar @{ $self->{'__stash'} } }
    sub __stash ($self) { $self->{'__stash'} }

    sub min ($self) {
        my $stash = $self->{'__stash'};
        return undef if @$stash == 0;
        return $stash->[0];
    }

    sub pop($self) {
        my $stash = $self->__stash;
        return undef if @$stash == 0;
        my $min = $stash->[0];

        $stash->[0] = $stash->[ $#$stash ];
        delete $stash->[ $#$stash ];

        my $cmp = $self->{"compare"};
        my $i = 0;
        while (2*$i+1 <= $#$stash) {
            my ($j1, $j2) = (2*$i+1, 2*$i+2);
            my $j = ($j2 <= $#$stash && ($cmp->($stash->[$j2], $stash->[$j1]) < 0)) ? $j2 : $j1;
            last if $cmp->($stash->[$i], $stash->[$j]) < 0;
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
                last if $self->{"compare"}->($stash->[$i], $stash->[$j]) < 0;
                ($stash->[$j], $stash->[$i]) = ($stash->[$i], $stash->[$j]);
                $j = $i;
            }
        }
    }
};

1;
__END__

=head1 Examples

    my $heap = AoC::MeanHeap::Num->new();

    # Add new values
    $heap->put($n);
    $heap->put(@nums);

    # Get the minimum value.
    $heap->min();

    # Remove the minimum value, and re-adjust the heap.
    my $n = $heap->pop();
