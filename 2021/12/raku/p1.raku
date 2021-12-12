
sub MAIN(IO::Path() $input) {
    my %connected;
    for $input.lines>>.split("-") -> @it {
        %connected{@it[1]}{@it[0]} = True;
        %connected{@it[0]}{@it[1]} = True;
    }

    my @all-paths = gather {
        my @stack = (["start"],);
        while @stack.elems > 0 {
            my $path = @stack.pop();

            my @connection = %connected{ $path[*-1] }.keys;

            for @connection -> $it {
                if $it.match(/^<[a..z]>+$/) && $path.first($it).defined {
                    next;
                }

                my $next-path = $path.clone();
                $next-path.append($it);

                if $it eq "end" {
                    take($next-path);
                } else {
                    @stack.push($next-path);
                }
            }
        }
    }

    # .join(",").say for @all-paths;
    say @all-paths.elems;
}
