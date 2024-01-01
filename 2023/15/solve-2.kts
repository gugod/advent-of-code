import java.io.File

fun main () {
    val boxes = (0..255).map { mutableListOf<Pair<String,Int>>() }.toList()
    val steps = File(args.getOrNull(0) ?: "input").readLines().joinToString("").split(",")
    steps.forEach {
        val l = labelFrom(it)
        val op = opFrom(it)
        val focal = focalFrom(it)
        val h = runHASH(l)
        when (op) {
            "=" -> upsert(boxes[h], l, focal!!)
            "-" -> remove(boxes[h], l)
            else -> throw IllegalStateException("not possible")
        }
    }

    val y = boxes.mapIndexed { i,lenses ->
        lenses.mapIndexed { j,lens -> (i+1) * (j+1) * lens.second }.sum()
    }.sum()
    println(y)
}

fun upsert (box: MutableList<Pair<String,Int>>, label: String, focalLength: Int) {
    val o = Pair(label, focalLength)
    val i = box.indices.firstOrNull { box[it].first == label }
    if (i == null) {
        box.add(o)
    } else {
        box[i] = o
    }
}

fun remove (box: MutableList<Pair<String,Int>>, label: String) {
    box.indices.firstOrNull { box[it].first == label }?.let {
        box.removeAt(it)
    }
}

fun labelFrom(x: String) = Regex("^[a-z]+").find(x)!!.value

fun opFrom(x: String) = Regex("[-=]").find(x)!!.value

fun focalFrom(x: String) = Regex("[0-9]$").find(x)?.value?.toInt()

fun runHASH (x: String): Int {
    var h: Int = 0
    x.forEach {
        h = ((h + it.code) * 17) % 256
    }
    return h
}

main()
