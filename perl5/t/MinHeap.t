use v5.36;
use Test2::V0;
use AoC::MinHeap::Str;
use AoC::MinHeap::Num;

sub minheap_sort ($class, $elems) {
    my $heap = $class->new();
    $heap->push(@$elems);
    is $heap->size, scalar(@$elems);

    my @out;
    push(@out, $heap->pop()) while $heap->size() > 0;
    return @out;
}

sub verify_minheap_str_can_sort ($elems) {
    my @sorted_by_minheap = minheap_sort 'AoC::MinHeap::Str', $elems;
    my @sorted = sort { $a cmp $b } @$elems;
    is \@sorted_by_minheap, \@sorted;
}

sub verify_minheap_num_can_sort ($elems) {
    my @sorted_by_minheap = minheap_sort 'AoC::MinHeap::Num', $elems;
    my @sorted = sort { $a <=> $b } @$elems;
    unless (is \@sorted_by_minheap, \@sorted) {
        diag join " ", @sorted;
        diag join " ", @sorted_by_minheap;
    }
}

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

    for my $round (1..1000) {
        my @elems = map { int(rand(10000)) } (1 .. 10+rand(100));
        subtest "fuzz round $round -- input " . join(" ", @elems), sub {
            verify_minheap_num_can_sort \@elems;
        };
    }
};

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

    for my $round (1..1000) {
        my @elems = map { chr(97 + rand 26) } (1..1000);
        subtest "fuzz round $round -- input " . join(" ", @elems), sub {
            verify_minheap_str_can_sort \@elems;
        };
    }

    subtest "previously failed input", sub {
        my @elems = qw(e c b f d a);
        verify_minheap_str_can_sort \@elems;
    };
};

done_testing;
