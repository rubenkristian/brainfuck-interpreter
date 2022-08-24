const std = @import("std");
const Allocator = std.mem.Allocator;
const heap = std.heap;
const bf = @import("./bf.zig");
const expect = std.testing.expect;

pub fn main() !void {
  const alloc: Allocator = heap.page_allocator;
  var args = try std.process.argsAlloc(alloc);
  defer alloc.free(args);

  if (args.len > 1) {
    const file: []const u8 = args[1];
    const content = try readFile(alloc, file);
    
    bf.Brainf.init(alloc);
    const tokens = bf.Brainf.tokenize(content);

    bf.Brainf.parse(tokens);
  } else {
    std.log.warn("missing brainfuck file", .{});
  }
}

fn readFile(allocator: Allocator, file: []const u8) ![]const u8 {
  const read_file = try std.fs.cwd().openFile(file, .{ .mode = .read_only });
  defer read_file.close();

  const file_size = (try read_file.stat()).size;
  var buffer = try allocator.alloc(u8, file_size);
  try read_file.reader().readNoEof(buffer);
  
  return buffer;
}

test "read file" {
  const allocator = heap.page_allocator;

  const content: []const u8 = try readFile(allocator, "test.bf");

  try expect(@TypeOf(content) == []const u8);
  try expect(std.mem.eql(u8, content, "+++++ +++++ >>++ >>++"));
}