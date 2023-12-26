import java.io.File

data class SpringProblem (
    val observation: String,
    val expectation: List<Int>,
)

data class SpringParts (
    val c: Char,
    val quantity: Int,
)

fun isMatch(problem: SpringProblem, guess: String): Boolean =
    problem.expectation == Regex("#+").findAll(guess).map { it.value.length }.toList()

fun isPartialMatch(problem: SpringProblem, guess: String): Boolean {
    val current = Regex("#+").findAll(guess).map { it.value.length }.toList()
    return if (current.isEmpty()) true else {
        current.count() <= problem.expectation.count() &&
            current.last() <= problem.expectation[current.lastIndex] &&
            (0 .. current.lastIndex - 1).all { i -> current[i] == problem.expectation[i] }
    }
}

fun countMatch(problem: SpringProblem, currentGuess: String, offset: Int): Int {
    if (offset > problem.observation.lastIndex) {
        return if (isMatch(problem, currentGuess)) 1 else 0
    }
    if (!isPartialMatch(problem, currentGuess)) {
        return 0
    }
    return when (problem.observation[offset]) {
        '?' -> {
            countMatch(problem, currentGuess + ".", offset + 1) + countMatch(problem, currentGuess + "#", offset + 1)
        }
        else -> {
            countMatch(problem, currentGuess + problem.observation[offset], offset + 1)
        }
    }
}

fun solveOne(problem: SpringProblem): Int = countMatch(problem, "", 0)

fun solve(problems: List<SpringProblem>) {
    problems.map { solveOne(it) }.sum().let { println(it) }
}

fun main(input: String) {
    val rows = File(input)
        .readLines()
        .map { line ->
            val cols = line.split(" ")
            SpringProblem(
                observation = cols[0],
                expectation = cols[1].split(",").map { it.toInt() },
            )
        }
    solve(rows)
}

main(args.getOrNull(0) ?: "input")
