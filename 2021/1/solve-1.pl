#!/usr/bin/env perl
use v5.34;
my @nums = do {
    open my $fh, "<", "input-1";
    <$fh>;
};
my $incs = grep { $nums[$_] > $nums[$_-1] } 1...$#nums;
say $incs;
