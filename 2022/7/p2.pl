use v5.36;
use File::Slurp qw(slurp);
use List::Util qw(first sum);

my $in = slurp("input");

my @dirs;
my %subdirOf;
my %sizeOf;
my $cwd = "/";
for my $line (split "\n", $in) {
    if ($line =~ /^\$ cd (?<dir>.+)$/) {
        if ($+{dir} eq "/") {
            $cwd = "/";
        } elsif ($+{dir} eq "..") {
            $cwd =~ s{/[^/]+$}{};
        } else {
            $cwd .= "/" . $+{dir};
        }
    }
    elsif ($line =~ /^\$ ls$/) {
    }
    elsif ($line =~ /^dir (?<subdir>.+)$/) {
        my $dir = $cwd . "/" . $+{subdir};
        push @dirs, $dir;
        push @{$subdirOf{$cwd} //= []}, $dir;
    }
    elsif ($line =~ /^(?<size>[0123456789]+) (?<file>.+)$/) {
        $sizeOf{$cwd} //= 0;
        $sizeOf{$cwd} += $+{size};
    }
    else {
        die "Strange: [$line]";
    }
}

sub totalSizeOf ($dir) {
    state %cache;
    return $cache{$dir} //= do {
        my $size = $sizeOf{$dir} // 0;
        for my $subdir (@{ $subdirOf{$dir} // []}) {
            $size += totalSizeOf($subdir);
        }
        $size;
    };
}

my $unused = 70000000 - totalSizeOf("/");

my $candidate = first {
    $unused + totalSizeOf($_) >= 30000000
} sort { totalSizeOf($a) <=> totalSizeOf($b) } @dirs;

say totalSizeOf($candidate);
