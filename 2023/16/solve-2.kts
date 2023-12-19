import java.io.File

data class Point(val y: Int, val x: Int)

enum class Dir(val b: Int) {
    NORTH(1),
    EAST(2),
    SOUTH(4),
    WEST(8),
}

data class BeamHead(val location: Point, val direction: Dir, val age: Int)

class BeamCastSimulator(
    val mirrorMap: List<String>
) {
    var energizedMap: Array<Array<Int>> =
        Array(mirrorMap.size) {
            Array(mirrorMap[0].length) {
                0
            }
        }

    val rowIndices = energizedMap.indices
    val colIndices = energizedMap[0].indices

    val beamHeadStack = ArrayDeque<BeamHead>()

    val deltaFromDir = hashMapOf<Dir,Pair<out Int,out Int>>(
        Dir.NORTH to Pair(-1,0),
        Dir.SOUTH to Pair(1,0),
        Dir.EAST to Pair(0,1),
        Dir.WEST to Pair(0,-1),
    )

    fun nextPointOf(beamHead: BeamHead) = nextPointOf(beamHead.location, beamHead.direction)

    fun nextPointOf(p: Point, direction: Dir): Point? =
        deltaFromDir
        .get(direction)!!
        .let { (dy,dx) ->
             val y = p.y + dy
             val x = p.x + dx
             if (mirrorMap.indices.contains(y) && mirrorMap[0].indices.contains(x))
                 Point(y, x)
             else
                 null
         }

    fun charAt(p: Point): Char? {
        return (if (0 <= p.y && p.y <= mirrorMap.lastIndex && 0 <= p.x && p.x <= mirrorMap[0].lastIndex) mirrorMap[p.y][p.x] else null)
    }

    fun countOfEnergizedCells () : Int {
        var count = 0
        rowIndices.forEach { y ->
            colIndices.forEach { x ->
                if (energizedMap[y][x] != 0)
                    count++
            }
        }
        return count
    }

    fun beamHeadWasHere (beamHead: BeamHead): Boolean =
        (energizedMap[beamHead.location.y][beamHead.location.x] and beamHead.direction.b) != 0

    fun beamHeadIsHere (beamHead: BeamHead) {
        energizedMap[beamHead.location.y][beamHead.location.x] =
            energizedMap[beamHead.location.y][beamHead.location.x] or beamHead.direction.b
    }

    fun beamTurnAndFork(beamHead: BeamHead): List<BeamHead> {
        var newBeamHeads = mutableListOf<BeamHead>()

        val p = beamHead.location
        val age = beamHead.age + 1

        when( charAt(p) ) {
            '.' -> newBeamHeads.add(BeamHead(p, beamHead.direction, age))
            '|' -> {
                when (beamHead.direction) {
                    in setOf(Dir.EAST, Dir.WEST) -> {
                        newBeamHeads.add(BeamHead(p, Dir.NORTH, age))
                        newBeamHeads.add(BeamHead(p, Dir.SOUTH, age))
                    }
                    else -> newBeamHeads.add(BeamHead(p, beamHead.direction, age))
                }
            }
            '-' -> {
                when (beamHead.direction) {
                    in setOf(Dir.NORTH, Dir.SOUTH) -> {
                        newBeamHeads.add(BeamHead(p, Dir.EAST, age))
                        newBeamHeads.add(BeamHead(p, Dir.WEST, age))
                    }
                    else -> newBeamHeads.add(BeamHead(p, beamHead.direction, age))
                }
            }
            '/' -> {
                when (beamHead.direction) {
                    Dir.NORTH -> newBeamHeads.add(BeamHead(p, Dir.EAST, age))
                    Dir.SOUTH -> newBeamHeads.add(BeamHead(p, Dir.WEST, age))
                    Dir.EAST -> newBeamHeads.add(BeamHead(p, Dir.NORTH, age))
                    Dir.WEST -> newBeamHeads.add(BeamHead(p, Dir.SOUTH, age))
                }
            }
            '\\' -> {
                when (beamHead.direction) {
                    Dir.NORTH -> newBeamHeads.add(BeamHead(p, Dir.WEST, age))
                    Dir.SOUTH -> newBeamHeads.add(BeamHead(p, Dir.EAST, age))
                    Dir.EAST -> newBeamHeads.add(BeamHead(p, Dir.SOUTH, age))
                    Dir.WEST -> newBeamHeads.add(BeamHead(p, Dir.NORTH, age))
                }
            }
            else -> {
                throw IllegalStateException("No idea how to process this: ${charAt(p)} $p")
            }
        }

        return newBeamHeads.toList()
    }

    fun adjustBeamHeads () {
        val limit = mirrorMap.size * mirrorMap[0].length + 1

        val newBeamHeads = beamHeadStack
            .removeLast()
            .let {
                beamHeadIsHere(it)
                beamTurnAndFork(it)
                    .filter { it.age < limit }
                    .mapNotNull {
                        nextPointOf(it)?.let { p ->
                            BeamHead(p, it.direction, it.age)
                        }
                    }
                    .filter {
                        !beamHeadWasHere(it)
                    }
            }

        beamHeadStack.addAll(newBeamHeads)
    }

    fun clearEnergizeMap () {
        rowIndices.forEach { y ->
            colIndices.forEach { x ->
                energizedMap[y][x] = 0
            }
        }
    }

    fun runOnce (initialBeamHead: BeamHead): Int {
        clearEnergizeMap()
        if (beamHeadStack.isNotEmpty())
            throw IllegalStateException("why isn't beamHeadStack empty")
        beamHeadStack.add(initialBeamHead)
        while (beamHeadStack.isNotEmpty()) {
            adjustBeamHeads()
        }
        return countOfEnergizedCells()
    }

    fun run () {
        var max = 0

        val lastRow = rowIndices.last()
        colIndices.forEach { x ->
            max = maxOf(max, runOnce(BeamHead(Point(0,x), Dir.SOUTH, 0)))
            max = maxOf(max, runOnce(BeamHead(Point(lastRow,x), Dir.NORTH, 0)))
        }

        val lastCol = colIndices.last()
        rowIndices.forEach { y ->
            max = maxOf(max, runOnce(BeamHead(Point(y,0), Dir.EAST, 0)))
            max = maxOf(max, runOnce(BeamHead(Point(y,lastCol), Dir.WEST, 0)))
        }

        println(max)
    }

    fun printEnergizedMap () {
        energizedMap.indices.forEach { y ->
            println(
                energizedMap[0].indices.map { x ->
                    when (energizedMap[y][x]) {
                        0 -> '.'
                        else -> energizedMap[y][x].toString(radix = 16)
                    }
                }.joinToString(".")
            )
        }
    }
}

val mirrorMap = File( if(args.size == 0) "input" else args[0] ).readLines().toList<String>()

BeamCastSimulator(mirrorMap).run()
