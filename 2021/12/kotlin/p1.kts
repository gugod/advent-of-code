// kotlinc -script p1.kts ../input

import java.io.File;

val connections: HashMap<String, MutableList<String>?> = hashMapOf()

File(args[0]).readLines().forEach {
    val seg = it.split("-")

    listOf(seg, seg.reversed()).forEach {
        val (a,b) = it;
        if (a != "end") {
            if (! connections.contains(a)) {
                connections.put(a, mutableListOf<String>())
            }
            if (b != "start") {
                connections.get(a)!!.add(b);
            }
        }
    }
}

val stack = mutableListOf( listOf("start") );

var allPaths = 0;

while (stack.size > 0) {
    val path = stack.removeLast()
    val cur = path.last()
    connections.get(cur)!!.forEach {
        if (it == "end") {
            allPaths++
        } else {
            if ((it.lowercase() != it) || (! path.contains(it))) {
                stack.add( path.plus(it) )
            }
        }
    }
}

println(allPaths)
