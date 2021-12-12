
sub MAIN(IO::Path() $input) {
    my %connected;
    for $input.lines>>.split("-") -> [$a, $b] {
        %connected{$a}{$b} = True unless $a eq "end" || $b eq "start";
        %connected{$b}{$a} = True unless $b eq "end" || $a eq "start";
    }

    my $all-paths = 0;

    # my @stack = ([False, {}, "start"],);
    my @stack = %connected<start>.keys.map({ [ False, %( $_ => True ), [$_] ] });
    while @stack.elems > 0 {
        my $path = @stack.pop();

        my @connection = %connected{ $path[*-1] }.keys;

        for @connection -> $it {
            if $it eq "end" {
                # say $next-path.join(",");
                $all-paths += 1;
            } else {
                my $is-lc = is-all-lowercase($it);
                my $duped = $is-lc && $path[1]{$it};
                next if $duped && $path[0];

                my $next-path = $path.clone();
                $next-path.append($it);
                $next-path[0] = True if !$path[0] && $duped;
                $next-path[1] = $path[1].clone();
                $next-path[1]{$it} = True if $is-lc;

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
