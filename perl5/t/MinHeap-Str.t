use Test2::V0;
use AoC::MinHeap::Str;

subtest 'AoC::MinHeap::Str', sub {
    subtest 'basics', sub {
        my $heap = AoC::MinHeap::Str->new();
        is $heap->pop(), undef;
        $heap->push("c","z","a", "b");

        is $heap->min(), "a";
        is $heap->pop(), "a";
        is $heap->min(), "b";
        is $heap->pop(), "b";
        is $heap->pop(), "c";
        is $heap->pop(), "z";
        is $heap->pop(), undef;
        is $heap->pop(), undef;
        is $heap->pop(), undef;
    };

    for my $round (1..10) {
        subtest "fuzz round $round", sub {
            my @elems = map { chr(32 + rand 30000) } (1..10);
            my @elems_sorted = sort { $a cmp $b } @elems;

            my $heap = AoC::MinHeap::Str->new();
            $heap->push(@elems);
            is $heap->size, 0+@elems;

            my @out;
            push(@out, $heap->pop()) for (1..10);
            is \@out, \@elems_sorted;
        }
    }
};

done_testing;
