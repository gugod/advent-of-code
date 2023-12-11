import java.io.File
import kotlin.math.abs

class Cosmos (
    val observation: List<String>,
) {
    private fun String.allIndicesOf(c: Char) = indices.filter { this[it] == c }

    val observedEmptyRows : List<Int> = observation.indices
        .filter { j -> observation[j].all { it == '.' } }

    val observedEmptyCols : List<Int> = observation[0].indices
        .filter { i -> observation.indices.all { j -> observation[j][i] == '.' } }

    val observedGalaxies : List<Pair<Int,Int>> =
        observation.flatMapIndexed { j, line -> line.allIndicesOf('#').map { Pair(j,it) } }

    val galaxies : List<Pair<Int,Int>> = observedGalaxies.map { (y,x) ->
        Pair(
            y + observedEmptyRows.filter { it < y }.count(),
            x + observedEmptyCols.filter { it < x }.count()
        )
    }

    fun sumOfPairwiseGalaticManhattonDistances() : Int {
        return galaxies.indices.map { i ->
            (i..galaxies.lastIndex).map { j ->
                abs(galaxies[i].first - galaxies[j].first) + abs(galaxies[i].second - galaxies[j].second)
            }.sum()
        }.sum()
        return 0
    }
}

println(
    Cosmos( observation = File("input").readLines().toList() )
        .sumOfPairwiseGalaticManhattonDistances()
        .toString()
)
