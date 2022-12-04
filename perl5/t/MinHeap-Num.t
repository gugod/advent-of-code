use Test2::V0;
use AoC::MinHeap::Num;

subtest 'AoC::MinHeap::Num', sub {
    subtest 'basics', sub {
        my $heap = AoC::MinHeap::Num->new( size => 3 );
        is $heap->pop(), undef;
        $heap->push(5,6,1,2);

        is $heap->min(), 1;
        is $heap->pop(), 1;
        is $heap->min(), 2;
        is $heap->pop(), 2;
        is $heap->pop(), 5;
        is $heap->pop(), 6;
        is $heap->pop(), undef;
        is $heap->pop(), undef;
        is $heap->pop(), undef;
    };
};

done_testing;
