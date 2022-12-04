use Test2::V0;
use AoC::MinHeap::Num;

subtest 'AoC::MinHeap::Num', sub {
    subtest 'basics', sub {
        my $heap = AoC::MinHeap::Num->new();
        is $heap->pop(), undef;
        $heap->push(5,6,1,2);

        is $heap->min(), 1;
        is $heap->pop(), 1;
        is $heap->min(), 2;
        is $heap->pop(), 2;
        is $heap->pop(), 5;
        is $heap->pop(), 6;
        is $heap->pop(), U();
        is $heap->pop(), U();
        is $heap->pop(), U();
    };

    for my $round (1..10) {
        subtest "fuzz round $round", sub {
            my @elems = map { int(rand(1000000)) } (1..10);
            my @elems_sorted = sort { $a <=> $b } @elems;

            my $heap = AoC::MinHeap::Num->new();
            $heap->push(@elems);
            is $heap->size, 0+@elems;

            my @out;
            push(@out, $heap->pop()) for (1..10);
            is \@out, \@elems_sorted;
        }
    };
};

done_testing;
