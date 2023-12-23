import java.io.File
import kotlin.text.Regex

fun lcmOf(a: Long, b: Long): Long {
    val larger = maxOf(a,b)
    val maxLcm = a * b
    var lcm = larger
    while (lcm <= maxLcm) {
        if (lcm % a == 0L && lcm % b == 0L) {
            return lcm
        }
        lcm += larger
    }
    return maxLcm
}

val lines = File(args.getOrNull(0) ?: "input").readLines()
val navigation = lines[0].toCharArray()
val network = lines.subList(2, lines.size)
    .fold(mutableMapOf<String,Pair<String,String>>()) { nw, line ->
        val nodes = Regex("[A-Z][A-Z][A-Z]").findAll(line).map { it.value.toString() }.toList()
        nw.apply { set(nodes[0], Pair(nodes[1], nodes[2])) }
    }

var currentNodes = network.keys.filter { it.endsWith("A") }

val rounds = currentNodes.map {
    var current = it
    var rounds = 0L
    var i = 0
    while (!current.endsWith("Z")) {
        val c = navigation[i]
        val leftRight = network.getValue(current)
        current = when (c) {
            'L' -> leftRight.first
            'R' -> leftRight.second
            else -> throw IllegalStateException("Which way ?")
        }
        i = (i + 1) % navigation.size
        rounds++
    }
    rounds
}

println(rounds.reduce { a,b -> lcmOf(a,b) })
