use v5.36;
use Test2::V0;
use JSON::PP qw(encode_json);
use AoC::MaxHeap;
use AoC::MaxHeap::Str;
use AoC::MaxHeap::Num;

sub maxheap_sort ($class, $elems) {
    my $heap = $class->new();
    $heap->push(@$elems);
    is $heap->size, scalar(@$elems);

    my @out;
    push(@out, $heap->pop()) while $heap->size() > 0;
    return @out;
}

sub verify_maxheap_can_sort ($heap, $elems, $elems_sorted) {
    $heap->push(@$elems);
    is $heap->size, scalar(@$elems);

    my @out;
    push(@out, $heap->pop()) while $heap->size() > 0;
    is \@out, $elems_sorted;
}

sub verify_maxheap_str_can_sort ($elems) {
    my @sorted_by_maxheap = maxheap_sort 'AoC::MaxHeap::Str', $elems;
    my @sorted = sort { $b cmp $a } @$elems;
    is \@sorted_by_maxheap, \@sorted;
}

sub verify_maxheap_num_can_sort ($elems) {
    my @sorted_by_maxheap = maxheap_sort 'AoC::MaxHeap::Num', $elems;
    my @sorted = sort { $b <=> $a } @$elems;
    unless (is \@sorted_by_maxheap, \@sorted) {
        diag join " ", @sorted;
        diag join " ", @sorted_by_maxheap;
    }
}

subtest 'AoC::MaxHeap::Num', sub {
    for my $round (1..100) {
        my @elems = map { int(rand(10000)) } (1 .. 10+rand(100));
        subtest "fuzz round $round -- input " . join(" ", @elems), sub {
            verify_maxheap_num_can_sort \@elems;
        };
    }
};

subtest 'AoC::MaxHeap::Str', sub {
    for my $round (1..100) {
        my @elems = map { chr(97 + rand 26) } (1 .. (10+rand(100)));
        subtest "fuzz round $round -- input " . join(" ", @elems), sub {
            verify_maxheap_str_can_sort \@elems;
        };
    }
};

subtest 'AoC::MaxHeap', sub {
    for my $round (1..100) {
        my @elems = map { [ chr(97 + rand 26) ] } (1 .. (10+rand(100)));
        my @elems_sorted = sort { $b->[0] cmp $a->[0] } @elems;
        subtest "fuzz round $round -- input " . encode_json(\@elems), sub {
            my $heap = AoC::MaxHeap->new(
                "compare" => sub ($a, $b) {
                    $a->[0] cmp $b->[0]
                }
            );
            verify_maxheap_can_sort $heap, \@elems, \@elems_sorted;
        };
    }
};

done_testing;
