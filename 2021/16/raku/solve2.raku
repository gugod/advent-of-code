
sub MAIN(IO::Path() $input) {
    say "# Examples";
    for (["C200B40A82", 3],
         ["04005AC33890", 54],
         ["880086C3E88112", 7],
         ["CE00C43D881120", 9],
         ["D8005AC2A8F0", 1],
         ["F600BC2D8F", 0],
         ["9C005AC2F8F0", 0],
         ["9C0141080250320F1802104A08", 1]) -> ($hexstr, $answer) {
        my ($offset, %packet) = decode-packet($hexstr, 0, 4 * $hexstr.chars);
        my $ans = eval-BITS(%packet);
        say "$ans -vs- $answer";
    }

    say "# Puzzle";
    my $hexstring = $input.slurp;
    my ($offset, %packet) = decode-packet($hexstring, 0, 4 * $hexstring.chars);
    say eval-BITS(%packet);
}

sub eval-BITS (%packet) {
    return %packet<literal-value> if %packet<type-id> == 4;
    my @sub-values = %packet<subpackets>.map({ eval-BITS($_) });

    my %compute = (
        0 => { [+] @sub-values },
        1 => { [*] @sub-values },
        2 => { @sub-values.min },
        3 => { @sub-values.max },
        5 => { @sub-values[0] > @sub-values[1] ?? 1 !! 0 },
        6 => { @sub-values[0] < @sub-values[1] ?? 1 !! 0 },
        7 => { @sub-values[0] == @sub-values[1] ?? 1 !! 0 },
    );
    return %compute{ %packet<type-id> }.();
}

sub decode-packet ($hexstring, $offset, $end) {
    return ($offset, Nil) unless $offset <= $end;

    my $bitpos = $offset;
    my sub read-bits ($n) {
        die "You read too much." if $bitpos >= $end;
        $bitpos += $n;
        return read-nbits($hexstring, $bitpos - $n, $n);
    }

    my sub discard-current-word {
        my $nbits = 4 - ($bitpos % 4);
        read-bits($nbits) if $nbits > 0;
    }

    sub decode-literal-value {
        my $b = read-bits(1);
        my $n = read-bits(4);
        while $b == 1 {
            $b = read-bits(1);
            my $_n = read-bits(4);
            $n = ($n +< 4) +| $_n;
        }
        # discard-current-word();
        return $n;
    }

    my %packet;
    %packet<_begin>  = $bitpos;
    %packet<version> = read-bits(3);
    %packet<type-id> = read-bits(3);

    if %packet<type-id> == 4 {
        %packet<literal-value> = decode-literal-value();
        %packet<_end> = $bitpos;
    }
    else {
        %packet<length-type-id> = read-bits(1);
        if %packet<length-type-id> == 0 {
            my $n = read-bits(15);
            %packet<_end> = $bitpos;
            %packet<_end-of-subpackets> = $bitpos + $n;

            my @subpackets;
            while $bitpos < %packet<_end-of-subpackets> {
                my ($pos, $p) = decode-packet($hexstring, $bitpos, $end);
                @subpackets.push($p);
                $bitpos = $pos;
            }
            %packet<subpackets> = @subpackets;
        }
        else {
            my $n = read-bits(11);
            %packet<_subpackets> = $n;
            %packet<_end> = $bitpos;
            my @subpackets;
            for ^$n {
                my ($pos, $p) = decode-packet($hexstring, $bitpos, $end);
                @subpackets.push($p);
                $bitpos = $pos;
            }
            %packet<subpackets> = @subpackets;
        }
    }

    return ($bitpos, %packet);
}

sub read-nbits ($hexstring, $bitpos, $n) {
    # Read n bits from $bitpos within $hexstring.
    # 1 word = 4 bits = "0".."F"

    my $out = 0;
    my $word-pos = $bitpos div 4;

    if $word-pos >= $hexstring.chars {
        die "Out of bound";
    }

    my $in-word-bitpos = $bitpos % 4;
    my $in-word-nbits  = min($n, 4 - $in-word-bitpos);
    my $bits-read = 0;

    my $words = ($in-word-bitpos + $n) div 4 + ( ($in-word-bitpos + $n) %% 4 ?? 0 !! 1);
    for ^$words {
        $out +<= 4;

        my $word = $hexstring.substr($word-pos , 1).parse-base(16);

        my $mask = 0b1111 +> $in-word-bitpos;

        if $in-word-bitpos + $in-word-nbits < 4 {
            my $truncate = 4 - $in-word-bitpos - $in-word-nbits;
            $mask +>= $truncate;
            $mask +<= $truncate;
        }
        $out +|= ($word +& $mask);

        $word-pos += 1;
        $in-word-bitpos = 0;
        $in-word-nbits = min($n - $bits-read, 4);
    }

    my $adjust = (4 - (($bitpos + $n) % 4)) % 4;
    $out +>= $adjust;

    return $out;
}
