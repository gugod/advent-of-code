"input".IO.slurp.split(/\n\n+/).map({
    .chomp.split(/<[ : \s ]>/).Hash
}).grep(
    -> %p {
        my $keys = %p.keys.elems;
        my $m;

        # Part 1
        ($keys == 8  || ($keys == 7 && (! %p<cid>)))
        # Part 2
        && (1920 <= %p<byr> <= 2002)
        && (2010 <= %p<iyr> <= 2020)
        && (2020 <= %p<eyr> <= 2030)
        && (
            ( ($m = %p<hgt>.match(/^ (<[0..9]>**3) cm $/)) && 150 <= $m[0] <= 193)
            || (($m = %p<hgt>.match(/^ (<[0..9]>**2) in $/)) && 59 <= $m[0] <= 76)
           )
        && %p<pid>.match(/^ <[ 0..9 ]>**9 $ /)
        && (%p<hcl>.match(/^ '#' <[ a..f 0..9 ]>**6 $ /))
        && %p<ecl> eq any("amb","blu","brn","gry","grn","hzl","oth")
    }).elems.say;
