const std = @import("std");
const heap = std.heap;
const bf = @import("./bf.zig");

fn main() !void {
    var buffer: [1000]u8 = undefined;
    var fba = heap.FixedBufferAllocator.init(&buffer);

    const allocator = fba.allocator();

    const point_list = try allocator.alloc(u8, 1000);
}