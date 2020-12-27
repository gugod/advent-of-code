 sub MAIN {
    my %stash = part1();
    part2(%stash);
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
                "borders" => %borders,
                "neighbours" => SetHash.new(),

                "any-borders" => %borders.values.flatmap(-> $b { ( $b, $b.flip ) }).any(),
                # Used in seam-all-borders
                "locked" => False,
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
                .first({ .<tile_id> ne $tile<id> and .<border> eq any($this_border, $this_border.flip) });

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

    say "... corners: " ~ @corners.map({ .<id> }).join(", ");

    say "Part 1: " ~ [*] @corners.map({ .<id> });

    return (
        "tiles" => %tiles,
        "all-borders" => @all-borders,
    );
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

sub rotate180($tile) {
    say "Rotate 180: " ~ $tile<id>;
}

sub seam-all-tiles(%stash) {
    my %tiles = %stash<tiles>;
    my @all-borders = %stash<all-borders>;

    my %other-side := {
        :top("bottom"),
        :bottom("top"),
        :left("right"),
        :right("left"),
    };

    my @canvas;

    # We assumed the number of tiles is a square numeber.
    my $width = %tiles.elems.sqrt;

    my %locked;

    # id => { top: id, left: ... }
    my %neighbours;
    my @todo;

    my sub self-orient ($tile) {
        for $tile<borders>.kv -> $side, $border {
            my $neighbour-tile-id = $tile<neighbours>.keys.first(
                -> $id {
                    %tiles{$id}<any-borders> eq $border
                }
            );
            if $neighbour-tile-id.defined {
                %neighbours{$tile<id>}{$side} = $neighbour-tile-id;
                @todo.push($neighbour-tile-id);
            }
        }
    }

    # Pick a random tile as the reference, adjuest all other tiles according to the orientation of this one.
    my $tile = %tiles.pick.value;

    self-orient($tile);
    %locked{ $tile<id> } = True;

    while @todo.elems > 0 {
        my $id = @todo.shift;
        next if %locked{$id};

        self-orient( %tiles{$id} );

        %locked{ $id } = True;
    }

    say "... corners: " ~ %neighbours.pairs.grep({ .value.elems == 2 }).map({ .key }).join(", ");

    return @canvas;
}

sub part2 (%stash) {
    my %tiles = %stash<tiles>;
    my @all-borders = %stash<all-borders>;
    # say %tiles;
    # say @all-borders;

    # The canvas we ar painting. An array of String
    my @canvas = seam-all-tiles(%stash);

    # preview(@canvas);
}
