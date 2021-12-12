
sub MAIN(IO::Path() $input) {
    my %connected;
    for $input.lines>>.split("-") -> [$a, $b] {
        %connected{$a}{$b} = True unless $a eq "end" || $b eq "start";
        %connected{$b}{$a} = True unless $b eq "end" || $a eq "start";
    }

    say all-paths-impl-recursion(%connected);
    # say all-paths-impl-stack(%connected);
}

sub all-paths-impl-recursion (%connected) {
    my $all-paths = 0;

    my sub traverse( $duped, @path ) {
        my $current := @path[*-1];

        my @params;
        for %connected{$current}.keys -> $next {
            if $next eq "end" {
                $all-paths += 1;
                # say $path.join(",");
                next;
            }

            my $is-lc-and-visited = $next.match(/^<[a..z]>/) && $next ∈ @path;
            next if $is-lc-and-visited && $duped;
            traverse($duped || $is-lc-and-visited, [|@path, $next]);
        }
    }

    traverse(False, ["start"]);

    return $all-paths;
}

sub all-paths-impl-stack (%connected) {
    my $all-paths = 0;

    # my @stack = ([False, {}, "start"],);
    my @stack = %connected<start>.keys.map({ [ False, set($_), $_ ] });
    while @stack.elems > 0 {
        my $path = @stack.pop();

        for %connected{ $path[*-1] }.keys -> $it {
            if $it eq "end" {
                # say $next-path.join(",");
                $all-paths += 1;
            } else {
                my $is-lc = $it.match(/^<[a..z]>/);
                my $duped = $path[1] ∋ $it;
                next if $is-lc && $duped && $path[0];

                my $next-path = $path.clone();
                $next-path[*-1] = $it;
                if $is-lc {
                    if $duped {
                        $next-path[0] = True if !$path[0];
                    } else {
                        $next-path[1] = $path[1] ∪ set($it);
                    }
                }

                @stack.push($next-path);
            }
        }
    }

    # .join(",").say for @all-paths;
    # say @all-paths.elems;
    return $all-paths;
}
