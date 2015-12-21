use v6;

my @inputs = open("input").lines;

my Int $nice1 = 0;
my Int $nice2 = 0;

for @inputs -> $line {
    $nice1++ if $line !~~ /(ab|cd|pq|xy)/ && $line ~~ /(.)$0/ && $line ~~ /<[aeiou]><-[aeiou]>*<[aeiou]><-[aeiou]>*<[aeiou]>/;
    $nice2++ if $line ~~ /(.).$0/ && $line ~~ /(..).*$0/;
}

say "Part 1: $nice1";
say "Part 2: $nice2";
