import java.io.File

private fun String.combLong(): Long =
    Regex("[0-9]+").findAll(this).map { it.value.toString() }.joinToString("").let { it.toLong() }

val inputLines = File(if (args.size == 0) "input" else args[0]).readLines()

val number = Regex("[0-9]+")
val raceTime = inputLines[0].combLong()
val recordDistance = inputLines[1].combLong()

var count = 0
(0..raceTime).forEach {
    if ((raceTime - it) * it > recordDistance) count++
}
println(count)
