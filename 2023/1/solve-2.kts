import java.io.File

val englishDigits = mapOf(
    "1" to 1,
    "2" to 2,
    "3" to 3,
    "4" to 4,
    "5" to 5,
    "6" to 6,
    "7" to 7,
    "8" to 8,
    "9" to 9,
    "one" to 1,
    "two" to 2,
    "three" to 3,
    "four" to 4,
    "five" to 5,
    "six" to 6,
    "seven" to 7,
    "eight" to 8,
    "nine" to 9,
)

val sumOfAll = File("input").readLines().map { line ->
    val calibers = line.indices.flatMap { i ->
        listOf(i+1, i+3, i+4, i+5)
            .filter { it <= line.lastIndex + 1 }
            .map { englishDigits.getOrDefault(line.substring(i,it), 0) }
            .filter { it != 0 }
    }
    10 * calibers.first() + calibers.last()
}.sum()

println("$sumOfAll")
