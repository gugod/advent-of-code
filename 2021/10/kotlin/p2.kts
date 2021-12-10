// kotlinc -script ./p1.kts ../input-example

import java.io.File

fun completionScore(line: String): Long {
    val openPar = arrayOf('(', '[', '{', '<');
    val closePar = arrayOf(')', ']', '}', '>');

    var stack = arrayListOf<Char>();
    var corrupted = false;
    for (c in line) {
        val i = closePar.indexOfFirst { it == c };
        if (i >= 0) {
            val o = stack.removeLast();
            if (o != openPar[i]) {
                corrupted = true;
                break;
            }
        } else {
            stack.add(c);
        }
    }

    val completionScore = arrayOf(1, 2, 3, 4);
    var score: Long = 0;
    if (!corrupted && stack.size > 0) {
        for (o in stack.reversed()) {
            val i = openPar.indexOfFirst { it == o };
            score = score * 5 + completionScore[i];
        }
    }

    return score;
}

// Part 2
val noise: List<String> = File(args[0]).readLines();
val scores = noise.map { completionScore(it) }.filter { it > 0 }.sorted();
if (scores.size > 0) {
    println(scores[ scores.size / 2 ]);
}
