import java.io.File

class EngineSchemata(
    val engineSchematic: List<String>,
) {
    private fun CharSequence.indicesOfNextNumOrNull (
        startIndex: Int,
    ) : IntRange? {
        if (startIndex > this.lastIndex)
            throw IllegalStateException("Your index is not my index.")

        val begin = (startIndex..this.lastIndex).firstOrNull { this[it].isDigit() }
        if (begin == null)
            return null

        val end = (begin..this.lastIndex).firstOrNull { ! this[it].isDigit() } ?: this.lastIndex+1
        return IntRange(begin,end-1)
    }

    private fun <T> cartesianProductOf (ys: List<T>, xs: List<T>) : List<Pair<T,T>> =
        ys.flatMap { y -> xs.map { x -> Pair(y,x) } }

    private fun rowEnd() = engineSchematic.lastIndex

    private fun colEnd() = engineSchematic[0].lastIndex

    private fun rowRange(xs: IntRange) = maxOf(0, xs.start) .. minOf(rowEnd(), xs.endInclusive)

    private fun colRange(xs: IntRange) = maxOf(0, xs.start) .. minOf(colEnd(), xs.endInclusive)

    private fun surrounding(
        lineIndex: Int,
        colIndices: IntRange,
    ) : List<Triple<Char,Int,Int>> =
        cartesianProductOf(
            rowRange(lineIndex - 1 .. lineIndex + 1).toList(),
            colRange(colIndices.start -1 .. colIndices.endInclusive + 1).toList(),
        )
        .filter { (j,i) ->
            ! ( j == lineIndex && i in colIndices ) && engineSchematic[j][i] != '.'
        }.map { (j,i) ->
            Triple(engineSchematic[j][i],j,i)
        }

    fun gearRatioSum() = engineSchematic
        .flatMapIndexed { j, line ->
            var partNumberInThisLine = mutableListOf<Pair<Int,Triple<Char,Int,Int>>>()
            var offset = 0
            while (offset < line.lastIndex) {
                val indices = line.indicesOfNextNumOrNull(offset)
                if (indices == null)
                    break
                offset = indices.endInclusive + 1

                val gearNearby = surrounding(j, indices).firstOrNull { it.first == '*' }
                if (gearNearby != null) {
                    val partNum = line.substring(indices).toInt()
                    partNumberInThisLine.add(Pair(partNum,gearNearby))
                }
            }

            partNumberInThisLine
        }
        .groupBy { (modelNum, gear) -> "${gear.second} ${gear.third}"  }
        .entries
        .filter { (k, partNums) -> partNums.size == 2 }
        .map { (k, partNums) -> partNums[0].first * partNums[1].first }
        .sum()

    fun play () {
        println( gearRatioSum().toString() )
    }
}

val machine = EngineSchemata( File("input").readLines().toList<String>() )
machine.play()
