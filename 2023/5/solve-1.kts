import java.io.File
import kotlin.text.Regex

class CategoryToCategoryMapper (
    val name: String,
    val source: String,
    val destination: String,
    val howTo: List<Triple<Long,Long,Long>>
) {
    fun convert(src: Long): Long {
        val rule = howTo.firstOrNull { it.second <= src && src < (it.second + it.third) }
        return if (rule == null) src else rule.first + (src - rule.second)
    }
}

private fun String.findAllNumbers() = Regex("[0-9]+").findAll(this).map { it.value.toLong() }

val input = File(if (args.size == 0) "input" else args[0]).readText()
val paragraphs = input.split("\n\n")

val seeds = paragraphs[0].findAllNumbers().toList()

val mappers = (1..paragraphs.lastIndex).map { i ->
    val lines = paragraphs[i].split("\n")
    val (src, _, dst, _) = lines[0].split( '-', ' ', limit = 4 )
    val howTo = (1..lines.lastIndex).flatMap {
        val nums = lines[it].findAllNumbers().toList()
        if (nums.size == 3)
            listOf(Triple(nums[0]!!, nums[1]!!, nums[2]!!))
        else
            listOf()
    }
    CategoryToCategoryMapper("$src-to-$dst", src, dst, howTo)
}

val mapper = mappers.first { it.source == "seed" }

var seedToLocationChain = mutableListOf<CategoryToCategoryMapper>(mapper)

while (seedToLocationChain.last().destination != "location") {
    seedToLocationChain.add(mappers.first { it.source == seedToLocationChain.last().destination })
}

val ans = seeds.map {
    var n = it
    seedToLocationChain.forEach { mapper ->
        n = mapper.convert(n)
    }
    n
}.min()

println(ans.toString())
