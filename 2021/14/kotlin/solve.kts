
import java.io.File

val lines = File(args[0]).readLines()
val polymers = lines[0]

val rules = lines.slice(2..lines.lastIndex).map { it.split(" -> ") }.associate { it[0] to it[1] }

var freq = hashMapOf<String,Long>()
polymers.windowed(2).forEach {
    freq.set(it, 1 + freq.getOrDefault(it, 0))
}
freq.set("_" + polymers.substring(0,1), 1 );
freq.set(polymers.substring( polymers.lastIndex, polymers.lastIndex+1) + "_", 1 );

// part 1: 1..10, part 2: 1..40
(1..40).forEach {
    var freq2 = hashMapOf<String,Long>()
    freq.forEach {
        val k = it.key
        val v = it.value;

        if (rules.containsKey(k)) {
            val (a,c) = it.key.windowed(1)
            val b = rules.getValue(k)

            freq2[a+b] = v + freq2.getOrDefault(a+b, 0)
            freq2[b+c] = v + freq2.getOrDefault(b+c, 0)
        } else {
            freq2.set(k, v)
        }
    }
    freq = freq2
}

var cfreq = hashMapOf<String,Long>()
freq.forEach { tok ->
    tok.key.windowed(1).forEach {
        c -> cfreq.put(c, tok.value + cfreq.getOrElse(c, { 0 }))
    }
}
cfreq.remove("_")

val cfreqvals: List<Long> = cfreq.map { it.value / 2 }
println( cfreqvals.maxOrNull()!! - cfreqvals.minOrNull()!! )
