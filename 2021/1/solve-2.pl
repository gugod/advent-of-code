#!/usr/bin/env perl
use v5.34;

my @lines = do {
    open my $fh, "<", "input-1";
    <$fh>;
};

my @nums = map { $lines[$_] + $lines[$_ - 1] + $lines[$_ - 2] } 2..$#lines;

my $incs = grep { $nums[$_] > $nums[$_-1] } 1...$#nums;

say $incs;
