#!/usr/bin/env raku

"input-1".IO.lines.rotor(2 => -1).grep({ .[1] > .[0] }).elems.say
