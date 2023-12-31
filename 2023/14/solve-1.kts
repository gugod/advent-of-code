import java.io.File

class Platform (val grid: List<List<Char>>) {
    val rowIndices = grid.indices
    val colIndices = grid[0].indices

    fun northTilted(): Platform {
        val newGrid = grid.map { it.toMutableList() }

        colIndices.forEach { x ->
            rowIndices.forEach { y ->
                if (newGrid[y][x] == '.') {
                    val y2 = (y+1 .. rowIndices.last()).firstOrNull { newGrid[it][x] == 'O' || newGrid[it][x] == '#' }
                    if (y2 != null && newGrid[y2][x] == 'O') {
                        newGrid[y][x] = 'O'
                        newGrid[y2][x] = '.'
                    }
                }
            }
        }
        return Platform(newGrid)
    }

    fun totalLoad(): Int {
        val rows = rowIndices.count()
        return rowIndices
            .map { y ->
                colIndices.filter { x -> grid[y][x] == 'O' }.count() * (rows - y)
            }
            .sum()
    }

    fun visual() {
        rowIndices.forEach {
            println(grid[it].joinToString(""))
        }
        println("")
    }
}

Platform(File(args.getOrNull(0) ?: "input").readLines().map { it.toList() })
    .northTilted()
    .totalLoad()
