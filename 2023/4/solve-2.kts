import java.io.File
import kotlin.math.pow
import kotlin.text.Regex

class Card (
    val id: Int,
    val winners: Set<Int>,
    val numbers: Set<Int>,
) {
    fun matchingNumbers () : Set<Int> = numbers.intersect(winners)
}

private fun String.findAllNumbers() = Regex("[0-9]+").findAll(this).map { it.value.toInt() }

val cards = File(if (args.size == 0) "input" else args[0]).readLines().map { line ->
    var lineParts = Regex("[:|]").split(line)
    Card(
        id = Regex(" +").split(lineParts[0])[1].toInt(),
        winners = lineParts[1].findAllNumbers().toSet(),
        numbers = lineParts[2].findAllNumbers().toSet(),
    )
}

var maxCardId = cards.last().id
var cardKeeper = cards.map { Pair(it.id,1) }.toMap().toMutableMap()

cards.map { card ->
    val copies = cardKeeper.get(card.id)!!
    (card.id + 1 .. card.id + card.matchingNumbers().count()).forEach { wonCardId ->
        if (wonCardId <= maxCardId) {
            cardKeeper.put(wonCardId, cardKeeper.get(wonCardId)!! + copies)
        }
    }
}

println(cardKeeper.values.sum().toString())
