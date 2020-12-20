sub MAIN {
    part1;
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
                "raw" => $raw,
                "rotate" => 0,
                "borders" => %borders,
                "neighbours" => %(
                    "top"    => Any,
                    "bottom" => Any,
                    "left"   => Any,
                    "right"  => Any,
                ),
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
        for $tile<neighbours>.pairs {
            next if .value.defined;
            my $side = .key;

            my $this_border = $tile<borders>{$side};
            my $that_border = @all-borders
                .grep({ .<tile_id> ne $tile<id> })
                .first({ .<border> eq any($this_border, $this_border.flip) });

            if ($that_border) {
                $tile<neighbours>{$side} = True;

                my $that_tile = %tiles{ $that_border<tile_id> };
                $that_tile<neighbours>{ $that_border<side> } = True;
            } else {
                $tile<neighbours>{$side} = False;
            }
        }
    }

    my @corners = %tiles.values.grep(
        -> $tile {
            $tile<neighbours>.values.grep(-> $it { $it == True }).elems == 2
        });

    die "Game over" unless @corners.elems == 4;
    say "Part 1: " ~ [*] @corners.map({ .<id> });
}
