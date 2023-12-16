import java.io.File

fun main () {
    val steps = File("input").readLines().joinToString("").split(",")
    println( steps.map { runHASH(it) }.sum().toString() )
}

fun runHASH (x: String): Int {
    var h: Int = 0
    x.forEach {
        h = ((h + it.code) * 17) % 256
    }
    return h
}

main()
