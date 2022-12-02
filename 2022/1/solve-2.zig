const std = @import("std");
const data = @embedFile("input.txt");

const print = std.debug.print;
const parseInt = std.fmt.parseInt;

pub fn main() anyerror!void {
    var lines = std.mem.split(u8, data, "\n");
    var cals: u64 = 0;
    var top3: [3]u64 = .{ 0, 0, 0 };
    while (lines.next()) |line| {
        if (line.len > 0) {
            var x: u64 = try parseInt(u64, line, 10);
            cals += x;
        } else {
            if (cals > top3[0]) {
                top3[2] = top3[1];
                top3[1] = top3[0];
                top3[0] = cals;
            } else if (cals > top3[1]) {
                top3[2] = top3[1];
                top3[1] = cals;
            } else if (cals > top3[2]) {
                top3[2] = cals;
            }
            cals = 0;
        }
    }

    print("{}\n", .{top3[0] + top3[1] + top3[2]});
}
