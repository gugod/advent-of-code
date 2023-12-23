import java.io.File

fun List<Long>.deltaSeries() = this.windowed(2,1) { (a,b) -> b - a }

fun List<Long>.isZeroSeries() = this.all { it == 0L }

fun List<Long>.guessNextOASIS(): Long =
    if (isZeroSeries()) 0L
    else last() + deltaSeries().guessNextOASIS()

val oasisReadings: List<List<Long>> = File(args.getOrNull(0) ?: "input").readLines().map { it.split(" ").map { it.toLong() }.toList() }

val y = oasisReadings.map { it.guessNextOASIS() }.sum()
println(y)
