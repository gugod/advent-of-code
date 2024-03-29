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
        let offset: u32 = u32::from_str(x[1]).expect("Err parsing offset");
        Ok(Instruction { command, offset })
    }
}

fn main() {
    let input = fs::read_to_string("input-1")
        .expect("fail input");

    let mut hpos = 0;
    let mut dpos = 0;
    for line in input.lines() {
        let x = Instruction::from_str(line).expect("Error parsing instruction");
        match x.command.as_str() {
            "forward" => hpos += x.offset,
            "up" => dpos -= x.offset,
            "down" => dpos += x.offset,
            _ => unreachable!(),
        }
    }
    println!("{}", hpos * dpos);
}
