const std = @import("std");

struct Image {
    data:  
}

pub fn main() !void {
    var size: u32 = 250;
    const cwd = std.fs.cwd();
    var image = try cwd.createFile("image.ppm", .{ .read = true });
    defer image.close();

    var prng = std.rand.DefaultPrng.init(blk: {
        var seed: u64 = undefined;
        try std.os.getrandom(std.mem.asBytes(&seed));
        break :blk seed;
    });
    const rand = prng.random();

    _ = try image.write("P3\n");
    var val: [10]u8 = undefined;
    _ = try std.fmt.bufPrint(&val, "{d} {d}\n", .{ size, size });
    _ = try image.write(&val);
    _ = try image.write("255\n");

    // Height
    for (0..size) |_| {
        // Width
        for (0..size) |_| {
            var color: [15]u8 = undefined;
            _ = try std.fmt.bufPrint(&color, "{d} {d} {d}\n", .{ rand.int(u8) % 255, rand.int(u8) % 255, rand.int(u8) % 255 });
            _ = try image.write(&color);
        }
    }
}
