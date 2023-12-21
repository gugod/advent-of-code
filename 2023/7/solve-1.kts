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
        fun fromString(hand: String) : HandType {
            val freq = hand.fold(hashMapOf<Char,Int>()) { f,c -> f.apply { set(c, f.getOrDefault(c,0)+1) } }

            return when(freq.keys.count()) {
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
        }
    }
}

fun cardRank(c: Char) = "23456789TJQKA".indexOf(c)

fun handToNum(hand: String) =
    HandType.fromString(hand).strongness * 13f.pow(5) + hand.mapIndexed { i,c -> cardRank(c) * (13f.pow(4-i))  }.sum()

File(args.getOrNull(0) ?: "input")
    .readLines()
    .map { it.split(" ") }
    .sortedBy { handToNum(it[0]) }
    .mapIndexed { i,xs -> xs[1].toInt() * (i + 1) }
    .sum()
    .run { println(this) }
