
sub MAIN(IO::Path() $input) {
    my %connected;
    for $input.lines>>.split("-") -> [$a, $b] {
        %connected{$a}{$b} = True unless $a eq "end" || $b eq "start";
        %connected{$b}{$a} = True unless $b eq "end" || $a eq "start";
    }

    my $all-paths = 0;

    my @stack = (["start"],);
    while @stack.elems > 0 {
        my $path = @stack.pop();

        my @connection = %connected{ $path[*-1] }.keys;

        for @connection -> $it {
            if is-all-lowercase($it) && $path.first($it).defined {
                next if no-more-lowercase-duper($path);
            }

            my $next-path = $path.clone();
            $next-path.append($it);

            if $it eq "end" {
                # say $next-path.join(",");
                $all-paths += 1;
            } else {
                @stack.push($next-path);
            }
        }
    }

    # .join(",").say for @all-paths;
    # say @all-paths.elems;
    say $all-paths;
}

sub is-all-lowercase (Str $s) {
    $s.match(/^<[a..z]>+$/)
}

sub no-more-lowercase-duper ($path) {
    my %freq;
    for $path.values.grep(&is-all-lowercase) -> $it {
        return True if ++%freq{$it} == 2;
    }
    return False;
}
