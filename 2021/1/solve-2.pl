#!/usr/bin/env perl
use v5.34;
my @nums = do {
    open my $fh, "<", "input-1";
    <$fh>;
};

my @wins = map {
    $nums[$_] + $nums[$_ - 1] + $nums[$_ - 2]
} 2..$#nums;

my $incs = grep { $wins[$_] > $wins[$_-1] } 1...$#wins;

say $incs;
