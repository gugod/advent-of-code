import java.io.File

fun partiallyMirrored(s1: String, s2: String) =
    with(s1.reversed()) { this.startsWith(s2) || s2.startsWith(this) }

fun vReflectAtCol(input: List<String>): Int {
    val lastCol = input[0].lastIndex
    var candidates = (0 .. lastCol-1).filter { x ->
        input.indices.all { y ->
            val left = input[y].substring(0,x+1)
            val right = input[y].substring(x+1)
            partiallyMirrored(left, right)
        }
    }
    return if (candidates.count() == 0) { 0 } else { candidates[0] + 1 }
}

fun hReflectAtRow(input: List<String>): Int {
    var n = 1
    var candidates = (0 .. input.lastIndex-1).filter { y ->
        input[0].indices.all { x ->
            val up = (0..y).map { input[it][x] }.joinToString("")
            val down = (y+1 .. input.lastIndex).map { input[it][x] }.joinToString("")
            partiallyMirrored(up, down)
        }
    }
    while (candidates.count() > 1) {
        candidates = candidates.filter { y -> (y - n + 1 >= 0) && (y + n <= input.lastIndex) && input[y-n+1] == input[y+n] }
        n++
    }
    return if (candidates.count() == 0) { 0 } else { candidates[0] + 1 }
}

fun solve(input: List<String>): Int = 100 * hReflectAtRow(input) + vReflectAtCol(input)

fun main(input: String) {
    val patterns: List<List<String>> = File(input).readText().split("\n\n").map { it.trimEnd('\n').split('\n') }
    patterns.map { solve(it) }.sum().let { println(it) }
}

main(args.getOrNull(0) ?: "input")
