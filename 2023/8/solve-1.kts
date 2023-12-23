import java.io.File
import kotlin.text.Regex

val lines = File(args.getOrNull(0) ?: "input").readLines()
val navigation = lines[0].toCharArray()
val network = lines.subList(2, lines.size)
    .fold(mutableMapOf<String,Pair<String,String>>()) { nw, line ->
        val nodes = Regex("[A-Z][A-Z][A-Z]").findAll(line).map { it.value.toString() }.toList()
        nw.apply { set(nodes[0], Pair(nodes[1], nodes[2])) }
    }

var current = "AAA"
var rounds = 0
var i = 0
while (current != "ZZZ") {
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
println(rounds)
