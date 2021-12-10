
sub MAIN(IO::Path() $input) {
    # Part 2: mediocre completion.
    my @scores;
    for $input.lines -> $line {
        my ($score, $completer) = corruption($line);
        next if $score > 0;
        @scores.push: completion-score($completer);
    }
    say @scores.sort.[ @scores.elems / 2 ];
}

sub completion-score($s) {
    state %score = ( ')' => 1, ']' => 2, '}' => 3, '>' => 4 );
    my $score = 0;
    for $s.comb -> $c {
        $score = ($score * 5) + %score{$c};
    }
    return $score;
}

sub corruption (Str $noise) {
    my $score = 0;
    my @st;
    for $noise.comb -> $c {
        if is-open($c) {
            @st.push($c);
        }
        else {
            my $o = @st.pop;
            my $want = closer($o);
            if $c ne $want {
                # say "corrupted: expected $want, got $c";
                $score += score($c);
                last;
            }
        }
    }
    return ($score, @st.map({ closer($_) }).reverse.join);
}

sub score($c) {
    state %score = ( ')' => 3, ']' => 57, '}' => 1197, '>' => 25137 );
    return %score{$c};
}

sub closer($c) {
    state %closer = ( '(' => ')', '[' => ']', '{' => '}', '<' => '>' );
    return %closer{$c};
}

sub opener($c) {
    state %opener = ( ')' => '(', ']' => '[', '}' => '{', '>' => '<' );
    return %opener{$c};
}

sub is-open($c) {
    $c eq '(' | '[' | '{' | '<'
}
