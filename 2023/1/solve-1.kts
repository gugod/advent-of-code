import java.io.File

val sumOfAll = File("input").readLines().map {
    val x = it.asIterable().filter { c -> c.isDigit() }

    val x1 = x.first().digitToInt()
    val x2 = x.last().digitToInt()

    10 * x1 + x2
}.sum()

println("$sumOfAll")
