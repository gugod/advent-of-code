
sub MAIN(IO::Path() $input) {
    ## Examples. Versions= 6, 16, 12, 23, 31
    # for ("D2FE28", "8A004A801A8002F478", "620080001611562C8802118E34", "C0015000016115A2E0802F182340", "A0016C880162017C3686B18A3D4780") -> $example {
    #     my ($offset, %packet) = decode-packet($example, 0, 4 * $example.chars);
    #     my $versionsum = sum-of-packet-versions(%packet);
    #     say $versionsum ~ "\t" ~ $example;
    # }

    my $hexstring = $input.slurp;
    my ($offset, %packet) = decode-packet($hexstring, 0, 4 * $hexstring.chars);
    my $versionsum = sum-of-packet-versions(%packet);
    say $versionsum;
}

sub sum-of-packet-versions (%packet) {
    my $versionsum = 0;
    my @stk;
    @stk.push: %packet;
    while @stk.elems > 0 {
        my $p = @stk.pop;
        $versionsum += $p<version>;
        if $p<subpackets>:exists {
            @stk.append: $p<subpackets>.values;
        }
    }
    return $versionsum;
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
