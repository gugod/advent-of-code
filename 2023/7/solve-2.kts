import java.io.File
import kotlin.math.pow

enum class HandType(val strongness: Int) {
    FiveOfAKind(7),
    FourOfAKind(6),
    FullHouse(5),
    ThreeOfAKind(4),
    TwoPair(3),
    OnePair(2),
    HighCard(1);

    companion object {
        fun fromFreq (freq: Map<Char,Int>): HandType =
            when(freq.keys.count()) {
                1 -> FiveOfAKind
                2 -> when(freq.values.max()) {
                         4 -> FourOfAKind
                         else -> FullHouse
                     }
                3 -> when(freq.values.max()) {
                         3 -> ThreeOfAKind
                         else -> TwoPair
                     }
                4 -> OnePair
                else -> HighCard
            }

        fun fromString(hand: String) : HandType {
            val freq = hand.fold(hashMapOf<Char,Int>()) { f,c -> f.apply { set(c, f.getOrDefault(c,0)+1) } }

            if (! freq.containsKey('J') || freq.keys.count() == 1) {
                return fromFreq(freq)
            }

            return freq.keys.minus('J').map { card ->
                fromFreq( freq.minus('J').plus(mapOf(card to (freq.getValue(card) + freq.getValue('J')))) )
            }.maxBy {
                it.strongness
            }
        }
    }
}

fun cardRank(c: Char) = "J23456789TQKA".indexOf(c)

fun handToNum(hand: String) =
    HandType.fromString(hand).strongness * 13.0.pow(5) + hand.mapIndexed { i,c -> cardRank(c) * (13.0.pow(4-i))  }.sum()

File(args.getOrNull(0) ?: "input")
    .readLines()
    .map { it.split(" ") }
    .sortedBy { handToNum(it[0]) }
    .mapIndexed { i,xs -> xs[1].toInt() * (i + 1) }
    .sum()
    .run { println(this) }
