
sub MAIN(IO::Path() $input) {
    my %connected;
    for $input.lines>>.split("-") -> [$a, $b] {
        %connected{$a}.push($b) unless $a eq "end" || $b eq "start";
        %connected{$b}.push($a) unless $b eq "end" || $a eq "start";
    }

    my sub traverse (&cb){
        my @stack = (["start"],);
        while @stack.elems > 0 {
            my $path = @stack.pop();
            for %connected{ $path[*-1] }.values -> $it {
                if $it eq "end" {
                    cb($path);
                } else {
                    next if $it.match(/^<[a..z]>/) && $it ∈ $path;
                    @stack.push([|$path, $it]);
                }
            }
        }
    }

    say elems gather { traverse { take($_) } };

    # my $all-paths = 0;
    # traverse { $all-paths++ }
    # say $all-paths;
}
