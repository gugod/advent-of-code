
import java.io.File;

fun vis (dots: List<List<Int>>): Unit {
    val xwidth = 1 + (dots.map { it[0] }.maxOrNull() ?: 0)
    val ywidth = 1 + (dots.map { it[1] }.maxOrNull() ?: 0)

    for (j in 0..ywidth) {
        var line = MutableList(xwidth) { " " }
        dots.filter { it[1] == j }.map { it[0] }.forEach {
            line.set(it, "█")
        }
        println(line.joinToString(""))
    }
}


val lines = File(args[0]).readLines()
var dotsOnPaper = lines
    .filter { it.contains(",") }
    .map { it.split(",") }
    .map { listOf<Int>(it[0].toInt(), it[1].toInt()) }

val foldingInstructions = lines
    .filter { it.contains("=") }
    .map {
        val i = it.indexOf("=")
        val axis = if (it.substring(i-1, i) == "x") 0 else 1
        val foldline = it.substring(i+1).toInt()

        Pair(axis, foldline)
    }

foldingInstructions.forEach { (axis, foldline) ->
        var p1 = dotsOnPaper.filter { it[axis] < foldline }
        var p2 = dotsOnPaper.filter { it[axis] >= foldline }.map {
            var it2 = it.toMutableList()
            it2[axis] = 2 * foldline - it[axis]
            it2.toList()
        }

        dotsOnPaper = p1.plus(p2).distinct()
        println( dotsOnPaper.size );
    }

vis(dotsOnPaper)
