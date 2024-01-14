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

fn count(comptime T: type, name: []const u8, digits: i32) !void {
    const baseI = pow10(u32, digits);
    const deno = pow10(T, digits);
    var err: usize = 0;
    var tested: usize = 0;
    for (0..baseI) |ia| {
        const a: T = floatCast(T, ia) / deno;
        for (ia..baseI) |ib| {
            const b: T = floatCast(T, ib) / deno;
            const cExpected: T = floatCast(T, ia + ib) / deno;
            const cActual = a + b;
            tested += 1;
            err += if (cExpected != cActual) 1 else 0;
        }
    }
    const percent = floatCast(f64, err) * 100 / floatCast(f64, tested);
    try stdout.print("{s:4} {d}: {d:9}/{d:9} errors ({d:.3}%)\n", .{ name, digits, err, tested, percent });
}
pub fn main() !void {
    for ([_]i32{ 1, 2, 3, 4 }) |digits| {
        try count(f16, "f16", digits);
        try count(f32, "f32", digits);
        try count(f64, "f64", digits);
        try count(f80, "f80", digits);
        try count(f128, "f128", digits);
    }
}
