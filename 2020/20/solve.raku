sub MAIN {
    my %tiles = part1;
    part2(%tiles);
}

sub part1 {
    my @tiles_raw = "input".IO.slurp.split("\n\n");
    my %tiles = @tiles_raw.map(
        -> $raw {
            my @lines = $raw.split("\n").grep({ .chars > 0 });
            my $tile_id = @lines.shift.comb(/<digit>+/).head;
            my %borders;

            # Canonicalized in the way as if they are rotated to the top side.
            %borders<top>    = @lines[0].Str;
            %borders<bottom> = @lines.tail.flip.Str;
            %borders<left>   = @lines.map({ .substr(0, 1) }).reverse.join("");
            %borders<right>  = @lines.map({ .substr(*-1, 1) }).join("");

            $tile_id => {
                "id" => $tile_id,
                "lines" => @lines,
                "rotate" => 0,
                "borders" => %borders,
                "neighbours" => SetHash.new(),
            }
        }
    );

    # Find 4 corners -- the ones with only 2 neighours
    # top-left corner does not have top/left neighbours
    # top-right corner does not have top/right neighbours
    # bottom-left corner does not have bottom/left neighbours
    # bottom-right corner does not have bottom/right neighbours

    my @all-borders = %tiles.values.flatmap(
        -> $tile {
            $tile<borders>.pairs.map({
                $%(
                    "tile_id" => $tile<id>,
                    "side"    => .key,
                    "border"  => .value,
                )
            })
        }
    );

    for %tiles.values -> $tile {
        next if $tile<neighbours>.elems == 4;
        for $tile<borders>.pairs {
            my $side = .key;

            my $this_border = $tile<borders>{$side};
            my $that_border = @all-borders
                .grep({ .<tile_id> ne $tile<id> })
                .first({ .<border> eq any($this_border, $this_border.flip) });

            if ($that_border) {
                my $that_tile = %tiles{ $that_border<tile_id> };
                # say "NEIGHBOUR: $tile<id> and $that_tile<id>";
                $tile<neighbours>.set($that_tile<id>);
                $that_tile<neighbours>.set($tile<id>);
            }
        }
    }

    my @corners = %tiles.values.grep(
        -> $tile {
            $tile<neighbours>.elems == 2
        });

    say "Part 1: " ~ [*] @corners.map({ .<id> });

    return %tiles;
}

sub paste-tile (@canvas, $tile, $y, $x) {
    for $tile<lines>.keys -> $j {
        @canvas[$y + $j] //= "";
        @canvas[$y + $j].substr-rw($x, $tile<lines>[$j].chars) = $tile<lines>[$j];
    }
}

sub preview (@canvas) {
    say "# Canvas";
    .say for @canvas;
}

sub part2 (%tiles) {
    # We assumed the number of tiles is a square numeber.
    my $width = %tiles.values.elems.sqrt;

    # The canvas we ar painting. An array of String
    my @canvas;

    # Seam all tiles starting from top-left corner as reference tile,
    # flip others, never this one.
    my $cursor-tile = %tiles.values.first(-> $t { $t<neighbours><left top>.none });
    say $cursor-tile<id>;
    my $cursor-y = 0;
    my $cursor-x = 0;
    paste-tile(@canvas, $cursor-tile, $cursor-y, $cursor-x);
    $cursor-x += $cursor-tile<lines>[0].chars - 1;

    preview(@canvas);

    # Seam the rest of tiles from top to down (row by row), from left to right.

    while $cursor-tile = $cursor-tile<neighbours><right> {
        say $cursor-tile<id>;
        paste-tile(@canvas, $cursor-tile, $cursor-y, $cursor-x);
        $cursor-x += $cursor-tile<lines>[0].chars - 1;
        # preview(@canvas);
    }
}
