import java.io.File
import kotlin.math.pow
import kotlin.text.Regex

class Card (
    val id: Int,
    val winners: Set<Int>,
    val numbers: Set<Int>,
) {
    fun points () : Int = 2f.pow( numbers.intersect(winners).count() -1).toInt()
}

private fun String.findAllNumbers() = Regex("[0-9]+").findAll(this).map { it.value.toInt() }

val cards = File("input").readLines().map { line ->
    var lineParts = Regex("[:|]").split(line)
    Card(
        id = Regex(" +").split(lineParts[0])[1].toInt(),
        winners = lineParts[1].findAllNumbers().toSet(),
        numbers = lineParts[2].findAllNumbers().toSet(),
    )
}

println(cards.map { it.points() }.sum())
