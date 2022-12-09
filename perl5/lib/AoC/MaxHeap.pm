use v5.36;

package AoC::MaxHeap {
    use Scalar::Util qw( looks_like_number );

    sub new ($class) {
        my $self = bless {
            __stash => [],
        }, $class;

        return $self;
    }

    sub size ($self) { scalar @{ $self->{'__stash'} } }
    sub __stash ($self) { $self->{'__stash'} }

    sub max ($self) {
        my $stash = $self->{'__stash'};
        return undef if @$stash == 0;
        return $stash->[0];
    }
};

1;
