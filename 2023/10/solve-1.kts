import java.io.File

enum class Dir { NORTH, EAST, SOUTH, WEST }

data class Coord (val y: Int, val x: Int)

class PipeNetwork (val sketch: List<String>) {
    val rows = sketch.indices
    val cols = sketch[0].indices

    private val dirsOfPipe = mapOf<Char,List<Dir>>(
        '|' to listOf(Dir.NORTH, Dir.SOUTH),
        '-' to listOf(Dir.EAST, Dir.WEST),
        'L' to listOf(Dir.NORTH, Dir.EAST),
        'J' to listOf(Dir.NORTH, Dir.WEST),
        '7' to listOf(Dir.WEST, Dir.SOUTH),
        'F' to listOf(Dir.EAST, Dir.SOUTH),
    );

    fun lookupSketch (p: Coord) = sketch[p.y][p.x]

    fun locateAnimal () : Coord {
        rows.forEach { y ->
            cols.forEach { x ->
                if (sketch[y][x] == 'S')
                    return Coord(y,x)
            }
        }
        throw IllegalStateException("No Animal?")
    }

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

    fun connectionOfPipe (p: Coord) =
        dirsOfPipe
        .get(lookupSketch(p))!!
        .let { conns ->
             neswOf(p).filterKeys { dir -> conns.any { it == dir } }
         }

    fun mainLoop () {
        var s = locateAnimal()
        val visited = hashSetOf<Coord>(s)
        var current = connectionOfAnimal(s).values
        var steps = 0
        while (current.count() != 0) {
            steps++
            current = current.flatMap {
                visited.add(it)
                connectionOfPipe(it).values
            }.filter { !visited.contains(it) }
        }
        println(steps)
    }
}

val nw = PipeNetwork(File(args.getOrNull(0) ?: "input").readLines())

val s = nw.locateAnimal()
println(s)

val t = nw.connectionOfAnimal(s)
println(t)

nw.mainLoop()
