// kotlinc -script p1.kts ../input-1

import java.io.File;

val inputLines = File(args[0]).readLines()
    .map{ it.split(" ") }
    .map{ Pair(it[0], it[1].toInt()) };

// Part 2;
var hpos = 0;
var dpos = 0;
var aim = 0;
for (input in inputLines) {
    val (d,x) = input;
    when (d) {
        "forward" -> { hpos += x; dpos += x * aim }
        "down"    -> aim += x
        "up"      -> aim -= x
    }
}
println(hpos * dpos);
