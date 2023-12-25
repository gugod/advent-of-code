import java.io.File

enum class Dir { NORTH, EAST, SOUTH, WEST }

data class Coord (val y: Int, val x: Int)

class PipeNetwork (val sketch: List<String>) {
    val rows = sketch.indices
    val cols = sketch[0].indices
    val animalLocation = rows.flatMap { y ->
        cols.mapNotNull { x ->
            if (sketch[y][x] == 'S')
                Coord(y,x)
            else
                null
        }
    }.first()!!

    fun lookupSketch (p: Coord) = sketch[p.y][p.x].let { if (it == 'S') pipeOfAnimal() else it }

    private val dirsOfPipe = mapOf<Char,List<Dir>>(
        '|' to listOf(Dir.NORTH, Dir.SOUTH),
        '-' to listOf(Dir.EAST, Dir.WEST),
        'L' to listOf(Dir.NORTH, Dir.EAST),
        'J' to listOf(Dir.NORTH, Dir.WEST),
        '7' to listOf(Dir.WEST, Dir.SOUTH),
        'F' to listOf(Dir.EAST, Dir.SOUTH),
    );

    fun neswOf (p: Coord): Map<Dir,Coord> =
        mapOf(
            Dir.NORTH to Coord(p.y-1, p.x),
            Dir.EAST  to Coord(p.y, p.x+1),
            Dir.SOUTH to Coord(p.y+1, p.x),
            Dir.WEST  to Coord(p.y, p.x-1),
        )
        .filterValues { rows.contains(it.y) && cols.contains(it.x) }

    fun connectionOfAnimal (p: Coord) =
        neswOf(p).filter { (dir,p) ->
            val c = lookupSketch(p)
            when (dir) {
                Dir.NORTH -> (listOf('|', '7', 'F').any { c == it })
                Dir.EAST  -> (listOf('-', '7', 'J').any { c == it })
                Dir.SOUTH -> (listOf('|', 'L', 'J').any { c == it })
                Dir.WEST  -> (listOf('-', 'L', 'F').any { c == it })
            }
        }

    fun pipeOfAnimal(): Char {
        val s = connectionOfAnimal( animalLocation ).keys
        return if (s.contains(Dir.NORTH)) {
            if (s.contains(Dir.SOUTH))     '|'
            else if (s.contains(Dir.EAST)) 'L'
            else if (s.contains(Dir.WEST)) 'J'
            else throw IllegalStateException("pipeOfAnimal N?")
        } else if (s.contains(Dir.EAST)) {
            if (s.contains(Dir.SOUTH))     'F'
            else if (s.contains(Dir.WEST)) '-'
            else throw IllegalStateException("pipeOfAnimal E?")
        } else if (s.contains(Dir.SOUTH)) {
            if (s.contains(Dir.WEST))      '7'
            else throw IllegalStateException("pipeOfAnimal S?")
        }
        else throw IllegalStateException("pipeOfAnimal ??")
    }

    fun connectionOfPipe (p: Coord) =
        dirsOfPipe
        .get(lookupSketch(p))!!
        .let { conns ->
             neswOf(p).filterKeys { dir -> conns.any { it == dir } }
         }

    fun mainLoopTiles () : HashSet<Coord> {
        var current = listOf<Coord>(animalLocation)
        val visited = hashSetOf<Coord>()
        while (current.count() != 0) {
            current = current.flatMap {
                visited.add(it)
                connectionOfPipe(it).values
            }.filter { !visited.contains(it) }
        }
        return visited
    }

    // Imagine the "." is pin-pointed at the upper-left corner of a tile.
    val eastWestTiles = setOf<Char>('-','7','J')
    val northSouthTiles = setOf<Char>('|','L','J')

    fun isInsideOf (p: Coord, loop: HashSet<Coord>) : Boolean {
        fun isEastWestTile(p: Coord) =
            eastWestTiles.contains(lookupSketch(p)) && loop.contains(p)

        fun isNorthSouthTile(p: Coord) =
            northSouthTiles.contains(lookupSketch(p)) && loop.contains(p)

        return listOf(
            (0 .. (p.y-1))         .filter { y -> isEastWestTile(Coord(y, p.x)) } .count(),
            ((p.y+1) .. rows.last) .filter { y -> isEastWestTile(Coord(y, p.x)) } .count(),
            (0 .. (p.x-1))         .filter { x -> isNorthSouthTile(Coord(p.y, x)) } .count(),
            ((p.x+1) .. cols.last) .filter { x -> isNorthSouthTile(Coord(p.y, x)) } .count(),
        ).let { cuts ->
            // println("DEBUG: $p --> $cuts")
            ! cuts.contains(0) && cuts.any { it % 2 == 1 }
        }
    }

    fun countOfTilesInsideOfMainLoop () :  Int {
        val mainLoop = mainLoopTiles()
        var count = 0
        rows.forEach { y ->
            cols.forEach { x ->
                val p = Coord(y,x)
                if (! mainLoop.contains(p)) {
                    if (isInsideOf(p, mainLoop)) {
                        count++
                    }
                }
            }
        }
        return count
    }

    fun visual () {
        val mainLoop = mainLoopTiles()
        rows.forEach { y ->
            cols.map { x ->
                Coord(y,x).let {
                    if (mainLoop.contains(it)) {
                        sketch[it.y][it.x]
                    } else {
                        if (isInsideOf(it, mainLoop)) {
                            'I'
                        } else {
                            'O'
                        }
                    }
                }
            }.joinToString("").let { println(it) }
        }
    }
}

val sketch = File(args.getOrNull(0) ?: "input").readLines()
val nw = PipeNetwork(sketch)

// nw.visual()

// listOf(Coord(4,4), Coord(4,7), Coord(4,8), Coord(4,9)).forEach {
//     val z = nw.isInsideOf(it, nw.mainLoopTiles())
//     // println("$it $z")
// }

println(nw.countOfTilesInsideOfMainLoop())
