import kotlin.text.Regex
import java.io.File

data class Round(
    val reds: Int = 0,
    val greens: Int = 0,
    val blues: Int = 0,
)

data class Game(
    val id: Int,
    val rounds: List<Round>,
)

val games = File("input").readLines().map { line ->
    val matchedGameId = Regex("Game ([0-9]+):").matchAt(line, 0)!!
    val gameId = matchedGameId.groups[1]!!.value.toInt()

    val rounds = Regex("; ")
        .split(line.substring(matchedGameId.range.endInclusive + 2))
        .map {
            var colors = mutableMapOf<String,Int>()
            Regex("([0-9]+) (red|green|blue),?").findAll(it).forEach {
                val n = it.groups[1]!!.value.toInt()
                val color = it.groups[2]!!.value.toString()
                colors.put(color, n)
            }
            Round(
                reds = colors.getOrDefault("red", 0),
                greens = colors.getOrDefault("green", 0),
                blues = colors.getOrDefault("blue", 0),
            )
        }
    Game(
        id = gameId,
        rounds = rounds
    )
}

val ans = games.map { game ->
    game.rounds.map { it.reds }.max() * game.rounds.map { it.greens }.max() * game.rounds.map { it.blues }.max()
}.sum()

println(ans)
