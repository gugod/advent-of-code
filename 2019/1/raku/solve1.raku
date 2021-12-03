
sub MAIN(IO::Path() $input) {
    $input.lines.map(*.Int).map({ ($_ / 3).floor - 2 }).sum().say()
}
