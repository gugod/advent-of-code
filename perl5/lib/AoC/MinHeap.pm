use v5.36;

package AoC::MinHeap {
    use Scalar::Util qw( looks_like_number );

    sub new ($class, %args) {
        die "size is required"
            unless defined($args{size}) && looks_like_number($args{size}) && $args{size} > 0;

        my $self = bless {
            size => $args{size},
            __stash => [],
        }, $class;

        return $self;
    }

    sub size ($self) { $self->{'size'} }
    sub __stash ($self) { $self->{'__stash'} }
};

1;
__END__

=head1 Examples

    my $heap = AoC::MeanHeap::Num->new( size => 10 );

    # Add new values
    $heap->put($n);
    $heap->put(@nums);

    # Get the minimum value.
    $heap->min();

    # Remove the minimum value, and re-adjust the heap.
    my $n = $heap->pop();
