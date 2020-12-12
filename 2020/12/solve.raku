
class ShipSim {
    has %!ship = {
        "facing" => "E",
        "x" => 0,
        "y" => 0,
    };

    has @!waypoint = (10, 1);

    has %!dirs = (
        'E' => ( 1 ,0),
        'W' => (-1, 0),
        'S' => ( 0,-1),
        'N' => ( 0, 1),
    );

    method report {
        return [ @!waypoint, %!ship<facing y x> ];
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
                self.rotate_waypoint_counterclockwise( $value / 90 );
            }
            when 'R' {
                self.rotate_waypoint_clockwise( $value / 90 );
            }
            when 'N' {
                self.move_waypoint( 'N', $value );
            }
            when 'S' {
                self.move_waypoint( 'S', $value );
            }
            when 'E' {
                self.move_waypoint( 'E', $value );
            }
            when 'W' {
                self.move_waypoint( 'W', $value );
            }
        }
    }

    method rotate_waypoint_clockwise(Int() $times) {
        for 1..$times {
            @!waypoint = @!waypoint[1, 0] <<*>> (1, -1);
        }
    }

    method rotate_waypoint_counterclockwise(Int() $times) {
        self.rotate_waypoint_clockwise(4 - ($times % 4))
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
        my $move = @!waypoint >>*>> $steps;
        %!ship<y> += $move[0];
        %!ship<x> += $move[1];
    }

    method move_waypoint (Str $dir, Int $steps) {
        my $move = %!dirs{$dir} >>*>> $steps;
        @!waypoint[0] += $move[0];
        @!waypoint[1] += $move[1];
    }
};

my $sim = ShipSim.new;

my @instructions = "input".IO.lines.map({ .match(/^ (<[ N S E W L R F ]>) (<digit>+) $/).map: *.Str; });

# say "    \t" ~ $sim.report;
for @instructions -> ($action, $value) {
    $sim.move($action, $value.Int);
    # say $action ~ $value ~ "\t" ~ $sim.report;
}

say "Mahatten Distance to O: " ~ $sim.manhatten-distance;
