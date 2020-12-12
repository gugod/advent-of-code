
class ShipSim {
    has %!ship = {
        "facing" => "E",
        "x" => 0,
        "y" => 0,
    };

    has %!dirs = (
        'E' => ( 1 ,0),
        'W' => (-1, 0),
        'S' => ( 0, 1),
        'N' => ( 0,-1),
    );

    method report {
        return [ %!ship<facing y x> ];
    }

    method manhatten-distance {
        %!ship<x y>.map({ .abs }).sum;
    }

    method move ($action, $value) {
        given ($action) {
            when 'F' {
                self.move_forward($value);
            }
            when 'L' {
                self.turn_left( $value / 90 );
            }
            when 'R' {
                self.turn_right( $value / 90 );
            }
            when 'N' {
                self.move_dir( 'N', $value );
            }
            when 'S' {
                self.move_dir( 'S', $value );
            }
            when 'E' {
                self.move_dir( 'E', $value );
            }
            when 'W' {
                self.move_dir( 'W', $value );
            }
        }
    }

    method turn_right( Int() $times ) {
        my %turn := {
            "E" => "S",
            "N" => "E",
            "W" => "N",
            "S" => "W",
        };

        for 1..$times {
            %!ship<facing> = %turn{ %!ship<facing> };
        }
    }

    method turn_left( Int() $times ) {
        my %turn := {
            "E" => "N",
            "N" => "W",
            "W" => "S",
            "S" => "E",
        };

        for 1..$times {
            %!ship<facing> = %turn{ %!ship<facing> };
        }
    }

    method move_forward (Int $steps) {
        my $move = %!dirs{ %!ship<facing> } >>*>> $steps;
        %!ship<y> += $move[0];
        %!ship<x> += $move[1];
    }

    method move_dir (Str $dir, Int $steps) {
        my $move = %!dirs{$dir} >>*>> $steps;
        %!ship<y> += $move[0];
        %!ship<x> += $move[1];
    }
};

my $sim = ShipSim.new;

my @instructions = "input".IO.lines.map({ .match(/^ (<[ N S E W L R F ]>) (<digit>+) $/).map: *.Str; });

for @instructions -> ($action, $value) {
    $sim.move($action, $value.Int);
}

say $sim.report;
say "Part 1: " ~ $sim.manhatten-distance;
