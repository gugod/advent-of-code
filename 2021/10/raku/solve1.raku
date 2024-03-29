
sub MAIN(IO::Path() $input) {
    # Part 1: total corruption.
    say [+] $input.lines.map(&corruption-score);
}

sub corruption-score (Str $noise) {
    my @chars = $noise.comb;

    my $score = 0;
    my @st;
    for @chars -> $c {
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

    return $score;
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
