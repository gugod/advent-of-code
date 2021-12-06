
sub MAIN(IO::Path() $input) {
    my @nums = $input.lines.comb(/\d+/).Array;
    # my @nums = (3,4,3,1,2);
    # play-latternfish(@nums, 80);
    play-latternfish(@nums, 256);
}

sub play-latternfish (@nums is copy, $days) {
    my %gen;
    @nums.map({ %gen{$_}++ });

    my $days_passed = 0;
    while $days_passed++ < $days {
        my %nextgen = (
            8 => (%gen{0} //0),
            7 => (%gen{8} //0),
            6 => (%gen{7} //0) + (%gen{0} //0),
            5 => (%gen{6} //0),
            4 => (%gen{5} //0),
            3 => (%gen{4} //0),
            2 => (%gen{3} //0),
            1 => (%gen{2} //0),
            0 => (%gen{1} //0),
        );
        %gen = %nextgen;
        # say $days_passed ~ "\t" ~ %gen.values.sum;
    }
    say %gen.values.sum;
}
