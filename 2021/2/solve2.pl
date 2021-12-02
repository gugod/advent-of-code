#!/usr/bin/env perl
use v5.34;

my @instructions = map { [split /\s+/] } do {
    open my $fh, "<", "input-1";
    <$fh>;
};

my ($hpos, $dpos, $aim) = (0, 0, 0);
my %on = (
    "forward" => sub {
        $hpos += $_[0];
        $dpos += $aim * $_[0];
    },
    "up"      => sub { $aim -= $_[0] },
    "down"    => sub { $aim += $_[0] },
);

for (@instructions) {
    my ($cmd, $offset) = @$_;
    $on{$cmd}->( $offset );
}

say $hpos * $dpos;
