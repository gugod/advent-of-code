use std::fs;

fn increases (numbers: Vec<i32>) -> i32 {
    let mut increases: i32 = 0;
    for nums in numbers.windows(2) {
        if nums[0] < nums[1]  {
            increases += 1;
        }
    }
    return increases;
}

fn main() {
    let filename: &str = "input-1";

    let contents = fs::read_to_string(filename)
        .expect("Something went wrong reading the file");

    let numbers: Vec<i32> = contents
        .split_whitespace()
        .map(|s| s.parse().expect("parse error"))
        .collect();

    let moving_sums: Vec<i32> = numbers.windows(3)
        .map(|it| it[0] + it[1] + it[2])
        .collect();

    println!("{}", increases(moving_sums));
}
