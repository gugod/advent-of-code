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

    private fun surroundingChars(
        lineIndex: Int,
        colIndices: IntRange,
    ) : CharArray {
        val w = engineSchematic.lastIndex
        val h = engineSchematic[0].lastIndex
        var chars = mutableListOf<Char>()

        (maxOf(0,lineIndex-1)..minOf(h,lineIndex+1)).forEach { j ->
            (maxOf(0, colIndices.start-1)..minOf(w, colIndices.endInclusive+1)).forEach { i ->
                if (! engineSchematic[j][i].isDigit()) {
                    chars.add(engineSchematic[j][i])
                }
            }
        }

        return chars.toCharArray()
    }

    fun play1 () {
        var sumOfAllPartNumbers = 0
        (0..engineSchematic.lastIndex).forEach { j ->
            val line = engineSchematic[j]
            var col = 0
            while (col < line.lastIndex) {
                val indices = line.indicesOfNextNumOrNull(col)
                if (indices == null)
                    break
                col = indices.endInclusive + 1

                if (surroundingChars(j, indices).any { it != '.' }) {
                    val partNum = line.substring(indices).toInt()
                    sumOfAllPartNumbers += partNum
                }
            }
        }
        println("$sumOfAllPartNumbers")
    }
}

val machine = EngineSchemata( File("input").readLines().toList<String>() )
machine.play1()
