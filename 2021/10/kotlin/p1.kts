// kotlinc -script ./p1.kts ../input-example

import java.io.File

fun corruptionScore(line: String): Int {
    val openPar = arrayOf('(', '[', '{', '<');
    val closePar = arrayOf(')', ']', '}', '>');
    val scorePar = arrayOf(3, 57, 1197, 25137);
    var score = 0;
    var stack = arrayListOf<Char>();

    for (c in line) {
        val i = closePar.indexOfFirst { it == c };
        if (i >= 0) {
            val o = stack.removeLast();
            if (o != openPar[i]) {
                score += scorePar[i];
                break;
            }
        } else {
            stack.add(c);
        }
    }

    return score;
}

// Part 1
val noise: List<String> = File(args[0]).readLines();
println(noise.map { corruptionScore(it) }.sum());
