use v5.20;
open my $fh, "<", "input";
my $vowel = qr![aeiou]!;
my $nice1 = 0;
my $nice2 = 0;
while (<$fh>) {
    chomp;
    $nice1++ if (!/ab|cd|pq|xy/ && /(.)\1/ && /[aeiou][^aeiou]*[aeiou][^aeiou]*[aeiou]/);
    $nice2++ if (/(.).\1/ && /(..).*\1/);
}
say "Part 1: $nice1";
say "Part 2: $nice2";
