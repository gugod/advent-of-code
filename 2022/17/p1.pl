use v5.36;
use FindBin '$Bin';
use lib $Bin . '/../../perl5/lib';
use AoC;
use Data::RoundRobin;
use Quantum::Superpositions qw(any);

main(@ARGV);
exit;

sub main ( $input = "input" ) {
    my $world = World->new(
        jets => [ parseInput($input) ],
        rocks => [ parseRocks("rocks") ],
    );

    $world->run(2022);
    say $world->towerHeight();
}

package World {
    use AoC;
    use Math::Vector::Real;
    use Quantum::Superpositions qw< any >;

    sub new ($class, %args) {
        bless {
            "rocks" => Data::RoundRobin->new(@{ $args{"rocks"} }),
            "jets" => Data::RoundRobin->new(@{ $args{"jets"} }),

            # The current floating rock object and its position.
            "_rock" => undef,
            "_rock_pos" => undef,

            "_width" => 7,
            "_height" => 1,
            "_map" => [
                [0,0,0,0,0,0,0] # index $i: at height $i above ground.
            ],
        }, $class
    }

    sub GIST ($self) {
        my %charMap = ( 0 => '.', 1 => '#' );
        my @screen;

        for my $row (@{ $self->{_map} }) {
            push @screen, [map { $charMap{$_} } @$row];
        }

        if ($self->{"_rock"} && $self->{"_rock_pos"}) {
            my $shape = $self->rockShape();

            for my $y (0 ... $self->rockHeight() - 1) {
                for my $x ( 0 ... $self->rockWidth() - 1 ) {
                    if ($shape->[$y][$x] eq '#') {
                        my $p = $self->{"_rock_pos"} + V(-$y, $x);

                        die $p unless 0 <= $p->[0] < @screen && 0 <= $p->[1] < elems($screen[0]);

                        $screen[ $p->[0] ][ $p->[1] ] = "@";
                    }
                }
            }
        }

        return join "\n",
            (map { join "", @$_ } reverse(@screen)),
            "\n";
    }

    sub height ($self) {
        elems $self->{"_map"}
    }

    sub width ($self) {
        $self->{"_width"}
    }

    sub rockWidth ($self) {
        $self->{"_rock"} && $self->{"_rock"}->width()
    }

    sub rockHeight ($self) {
        $self->{"_rock"} && $self->{"_rock"}->height()
    }

    sub rockShape ($self) {
        $self->{"_rock"} && $self->{"_rock"}->shape()
    }

    sub towerHeight ($self) {
        my $map = $self->{"_map"};
        my $h = $#{ $self->{"_map"} };
        while ($h >= 0) {
            last if any( @{$map->[$h]} ) != 0;
            $h--;
        }
        return $h;
    }

    sub run ($self, $rounds) {
        for (1..$rounds) {
            $self->runOneRound();
        }
    }

    sub runOneRound ($self) {
        $self->rockAppears();

        while (true) {
            $self->gravitate() or last;
        }
        $self->consolidate();
        # say $self->GIST;
        # say "\n#########\n";
    }

    sub expendMap ($self, $rock) {
        # Make map taller so the top part is 3 empty rows + the height of $rock.
        my $d = $self->towerHeight() + 3 + $rock->height() - $self->height();
        push @{$self->{_map}}, map { [(0) x $self->width() ] } (0..$d);
    }

    sub rockAppears ($self) {
        my $rock = $self->{"rocks"}->next;

        $self->expendMap($rock);

        # The top-left corner of a $rock is its anchor point to the world.
        $self->{"_rock"} = $rock;
        $self->{"_rock_pos"} = V($self->height()-1, 2);

        return $rock;
    }

    sub gravitate ($self) {
        my $nextPos = $self->{"_rock_pos"} + V(-1,0);
        if ( $self->mayCollide($nextPos) ) {
            return false;
        }
        $self->{"_rock_pos"} = $self->{"_rock_pos"} + V(-1,0);
        return true;
    }

    sub consolidate ($self) {
        for my $y (0 ... $self->rockHeight() - 1) {
            for my $x ( 0 ... $self->rockWidth() - 1 ) {
                if ((my $it = $self->rockShape()->[$y][$x]) eq '#') {
                    my $p = $self->{"_rock_pos"} + V(-$y, $x);

                    $self->{"_map"}[ $p->[0] ][ $p->[1] ] = 1;
                }
            }
        }
    }


    sub mayCollide ($self, $nextPos) {
        return true if $nextPos->[0] - $self->rockHeight() + 1 < 0;
        return true if $nextPos->[1] < 0;
        return true if $nextPos->[1] + $self->rockWidth() >= $self->width();

        for my $y (0 ... $self->rockHeight() - 1) {
            for my $x ( 0 ... $self->rockWidth() - 1 ) {
                if ((my $it = $self->rockShape()->[$y][$x]) eq '#') {
                    my $p = $nextPos + V(-$y, $x);

                    return true if $self->{"_map"}[ $p->[0] ][ $p->[1] ] == 1;
                }
            }
        }

        return false
    }
}

package Rock {
    use AoC;

    sub new ($class, $raw) {
        ;
        bless {
            raw => $raw,
            shape => [map { [ split "", $_] } split /\n/, $raw],
        }, $class
    }

    sub GIST ($self) { $self->{"raw"} }

    sub width ($self) {
        elems $self->{shape}[0]
    }
    sub height ($self) {
        elems $self->{shape}
    }
    sub shape ($self) {
        $self->{"shape"}
    }

}

sub parseInput ($input) {
    comb qr/<>/, scalar slurp("input")
}

sub parseRocks ($input) {
    map { Rock->new($_) } split "\n\n", scalar slurp($input)
}
