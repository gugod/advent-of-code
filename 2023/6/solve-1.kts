import java.io.File

private fun String.combInt(): List<Int> =
    Regex("[0-9]+").findAll(this).map { it.value.toInt() }.toList()

val inputLines = File(if (args.size == 0) "input" else args[0]).readLines()

val number = Regex("[0-9]+")
val time = inputLines[0].combInt()
val distance = inputLines[1].combInt()
val raceIndices = time.indices

raceIndices
    .map { i ->
        val raceTime = time[i]
        val recordDistance = distance[i]
        (0..raceTime).filter { (raceTime - it) * it > recordDistance }.count()
    }
    .filter {
        it > 0
    }
    .reduce { a,b -> a*b }
    .let { println(it) }
