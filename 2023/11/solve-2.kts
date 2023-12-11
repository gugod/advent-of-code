import java.io.File
import kotlin.math.abs

class Cosmos (
    val observation: List<String>,
    val expansionFactor: Long,
) {
    private fun String.allIndicesOf(c: Char) = indices.filter { this[it] == c }

    val observedEmptyRows : List<Int> = observation.indices
        .filter { j -> observation[j].all { it == '.' } }

    val observedEmptyCols : List<Int> = observation[0].indices
        .filter { i -> observation.indices.all { j -> observation[j][i] == '.' } }

    val observedGalaxies : List<Pair<Int,Int>> =
        observation.flatMapIndexed { j, line ->
            line.allIndicesOf('#').map { Pair(j,it) }
        }

    val galaxies : List<Pair<Long,Long>> = observedGalaxies.map { (y,x) ->
        val dy = (expansionFactor - 1) * observedEmptyRows.filter { it < y }.count()
        val dx = (expansionFactor - 1) * observedEmptyCols.filter { it < x }.count()
        Pair(y + dy, x + dx)
    }

    fun sumOfPairwiseGalaticManhattonDistances() : Long {
        return galaxies.indices.map { i ->
            (i..galaxies.lastIndex).map { j ->
                abs(galaxies[i].first - galaxies[j].first) + abs(galaxies[i].second - galaxies[j].second)
            }.sum()
        }.sum()
    }
}

println(
    Cosmos( observation = File("input").readLines().toList(), expansionFactor = 1000000 )
        .sumOfPairwiseGalaticManhattonDistances()
        .toString()
)
