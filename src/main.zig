const std = @import("std");
const Allocator = std.mem.Allocator;
const heap = std.heap;
const bf = @import("./bf.zig");

pub fn main() !void {
    const alloc: Allocator = heap.page_allocator;
    var args = try std.process.argsAlloc(alloc);
    defer alloc.free(args);

    if (args.len > 1) {
        const file: []const u8 = args[1];
        std.debug.print("{s}", .{file});
    }
}