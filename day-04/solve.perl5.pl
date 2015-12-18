use v5.20;
use Digest::MD5 qw(md5_hex);
open my $fh, "<", "input";
my $input = <$fh>;
chomp($input);

my $md5;
my $num = 0;
my $part1;
while (1) {
    $md5 = md5_hex($input . $num);
    my $c = 0;
    while (substr($md5, $c, 1) eq "0") {
        $c++;
    }
    if ($c >= 5) {
        if (!$part1) {
            $part1 = $num;
            say "Part 1: $num ( $input$num\t$md5 )";
        }
        if ($c >= 6) {
            say "Part 2: $num ( $input$num\t$md5 )";
            last;
        }
    }
    $num++;
}
