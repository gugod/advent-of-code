use v5.36;

package AoC::MinHeap {
    use Scalar::Util qw( looks_like_number );

    sub new ($class) {
        my $self = bless {
            __stash => [],
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
