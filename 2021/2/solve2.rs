use std::fs;
use std::str::FromStr;

struct Instruction {
    command: String,
    offset: u32,
}

impl FromStr for Instruction {
    type Err = std::num::ParseIntError;
    fn from_str (line: &str) -> Result<Self, Self::Err> {
        let x: Vec<&str> = line.split_whitespace().collect();
        let command: String = x[0].to_string();
        let offset: u32 = u32::from_str(x[1]).unwrap();
        Ok(Instruction { command, offset })
    }
}

fn main() {
    let input = fs::read_to_string("input-1")
        .expect("fail input");

    let mut hpos = 0;
    let mut dpos = 0;
    let mut aim = 0;
    for line in input.lines() {
        let x = Instruction::from_str(line).unwrap();
        match x.command.as_str() {
            "forward" => {
                hpos += x.offset;
                dpos += aim * x.offset;
            },
            "up" => aim -= x.offset,
            "down" => aim += x.offset,
            _ => ()
        }
    }
    println!("{}", hpos * dpos);
}
