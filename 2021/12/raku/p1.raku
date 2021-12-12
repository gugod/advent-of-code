
sub MAIN(IO::Path() $input) {
    my %connected;
    for $input.lines>>.split("-") -> [$a, $b] {
        %connected{$a}.push($b) unless $a eq "end" || $b eq "start";
        %connected{$b}.push($a) unless $b eq "end" || $a eq "start";
    }

    my @all-paths = gather {
        my @stack = (["start"],);
        while @stack.elems > 0 {
            my $path = @stack.pop();
            for %connected{ $path[*-1] }.values -> $it {
                if $it eq "end" {
                    take($path);
                } else {
                    next if $it.match(/^<[a..z]>/) && $path.first($it).defined;
                    my $next-path = $path.clone().append($it);
                    @stack.push($next-path);
                }
            }
        }
    }

    # .join(",").say for @all-paths;
    say @all-paths.elems;
}
