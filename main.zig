const std = @import("std");
const stdout = std.io.getStdOut().writer();

fn pow10(comptime T: type, digits: i32) T {
    if (digits <= 0) {
        return 1;
    }
    return pow10(T, digits - 1) * 10;
}

fn floatCast(comptime T: type, a: usize) T {
    return @as(T, @floatFromInt(a));
}

fn countMatch(comptime T: type, digits: i32) f64 {
    const baseI = pow10(u32, digits);
    const deno = pow10(T, digits);
    var matched: usize = 0;
    var tested: usize = 0;
    for (0..baseI) |ia| {
        const a: T = floatCast(T, ia) / deno;
        for (ia..baseI) |ib| {
            const b: T = floatCast(T, ib) / deno;
            const cExpected: T = floatCast(T, ia + ib) / deno;
            const cActual = a + b;
            tested += 1;
            matched += if (cExpected == cActual) 1 else 0;
        }
    }
    return floatCast(f64, matched) * 100 / floatCast(f64, tested);
}
pub fn main() !void {
    const r = countMatch(f64, 2);
    try stdout.print("{d}\n", .{r});
}
