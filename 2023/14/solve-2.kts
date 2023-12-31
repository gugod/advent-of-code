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

    fun southTilted(): Platform {
        val newGrid = grid.map { it.toMutableList() }

        colIndices.forEach { x ->
            rowIndices.reversed().forEach { y ->
                if (newGrid[y][x] == '.') {
                    val y2 = (0 .. y-1).reversed().firstOrNull { newGrid[it][x] == 'O' || newGrid[it][x] == '#' }
                    if (y2 != null && newGrid[y2][x] == 'O') {
                        newGrid[y][x] = 'O'
                        newGrid[y2][x] = '.'
                    }
                }
            }
        }
        return Platform(newGrid)
    }

    fun eastTilted(): Platform {
        val newGrid = grid.map { it.toMutableList() }
        rowIndices.forEach { y ->
            colIndices.reversed().forEach { x ->
                if (newGrid[y][x] == '.') {
                    val x2 = (0 .. x-1).reversed().firstOrNull { newGrid[y][it] == 'O' || newGrid[y][it] == '#' }
                    if (x2 != null && newGrid[y][x2] == 'O') {
                        newGrid[y][x] = 'O'
                        newGrid[y][x2] = '.'
                    }
                }
            }
        }
        return Platform(newGrid)
    }

    fun westTilted(): Platform {
        val newGrid = grid.map { it.toMutableList() }
        rowIndices.forEach { y ->
            colIndices.forEach { x ->
                if (newGrid[y][x] == '.') {
                    val x2 = (x+1 .. colIndices.last()).firstOrNull { newGrid[y][it] == 'O' || newGrid[y][it] == '#' }
                    if (x2 != null && newGrid[y][x2] == 'O') {
                        newGrid[y][x] = 'O'
                        newGrid[y][x2] = '.'
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

var initialLoads = mutableListOf<Int>()
var p = Platform(File(args.getOrNull(0) ?: "input").readLines().map { it.toList() })

var cycles = 0
while (cycles++ < 1000) {
    p = p.northTilted().westTilted().southTilted().eastTilted()
    initialLoads.add(p.totalLoad())
}

val repeatLength = (1..999).first { len ->
    ( (initialLoads.lastIndex - len + 1) .. initialLoads.lastIndex ).all { i -> initialLoads[i] == initialLoads[i-len] }
}

val k = (1000000000 - 1000) % repeatLength

initialLoads[1000 - 1 - (repeatLength - (k % repeatLength))]
