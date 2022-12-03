//  kotlinc -script ./p2.kts ../input.txt

import java.io.File

fun scoreOf(c: Char): Int {
    val s = c.code - 'a'.code + 1;
    return if (s > 0) { s } else { c.code - 'A'.code + 27 };
}

fun scoreOf(threeRucksack: List<String>): Int =
    scoreOf(
        threeRucksack
            .map { it.chunked(1).map { it[0] }.toSet<Char>() }
            .reduce { e1, e2 -> e1.intersect(e2) }
            .first()
    );

var carries = File(args[0]).readLines().chunked(3);
var score = carries.map { scoreOf(it) }.sum();
println("${score}");
