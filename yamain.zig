const std = @import("std");
const stdout = std.io.getStdOut().writer();

fn pow10(comptime T: type, digits: anytype) T {
    if (digits <= 0) {
        return 1;
    }
    return pow10(T, digits - 1) * 10;
}

fn floatCast(comptime T: type, a: anytype) T {
    return @as(T, @floatFromInt(a));
}

fn div(comptime T: type, a: anytype, d: anytype) T {
    const fa = floatCast(f128, a);
    const fd = floatCast(f128, d);
    const x = fa / fd;
    return @as(T, @floatCast(x));
}

fn count(comptime T: type, name: anytype, digits: i32) !void {
    const baseI = pow10(u32, digits);
    var err: usize = 0;
    var tested: usize = 0;
    for (1..(baseI + 1)) |ia| {
        const a: T = div(T, ia, baseI);
        for (ia..(baseI + 1)) |ib| {
            const b: T = div(T, ib, baseI);
            const cExpected: T = div(T, ia + ib, baseI);
            const cActual = a + b;
            tested += 1;
            err += if (cExpected != cActual) 1 else 0;
        }
    }
    const percent = floatCast(f64, err) * 100 / floatCast(f64, tested);
    try stdout.print("{s:4} {d}: {d:11}/{d:11} errors ({d:.3}%)\n", .{ name, digits, err, tested, percent });
}
pub fn main() !void {
    for ([_]i32{ 1, 2, 3, 4, 5 }) |digits| {
        try count(f16, "f16", digits);
    }
}
