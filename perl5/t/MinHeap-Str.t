use Test2::V0;
use AoC::MinHeap::Str;

subtest 'AoC::MinHeap::Str', sub {
    subtest 'basics', sub {
        my $heap = AoC::MinHeap::Str->new( size => 3 );
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
};

done_testing;
