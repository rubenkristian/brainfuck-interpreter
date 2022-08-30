const std = @import("std");
const Allocator = std.mem.Allocator;
const heap = std.heap;
const bf = @import("./bf.zig");
const expect = std.testing.expect;

const ReadError = error {
  FileNotFound,
  AllocatorError,
  StatError,
  ReaderError,
};

pub fn main() !void {
  const alloc = heap.page_allocator;
  var args = try std.process.argsAlloc(alloc);
  defer alloc.free(args);

  if (args.len > 1) {
    const file: []const u8 = args[1];
    const content = readFile(alloc, file) catch |readError| {
      switch (readError) {
        ReadError.FileNotFound => {
          std.log.err("File not found", .{});
        },
        ReadError.AllocatorError => {
          std.log.err("Allocation error", .{});
        },
        ReadError.StatError => {
          std.log.err("Cannot check file", .{});
        },
        ReadError.ReaderError => {
          std.log.err("Cannot read file", .{});
        }
      }
      return;
    };
    
    var brainfuck = try bf.Brainf.init(alloc);
    defer brainfuck.deinit();

    // brainfuck.reset();
    _ = try brainfuck.tokenize(content);

    try brainfuck.Interpreter();
  } else {
    std.log.warn("missing command brainfuck file", .{});
  }
}

fn readFile(allocator: Allocator, file: []const u8) ReadError![]const u8 {
  const read_file = std.fs.cwd().openFile(file, .{ .mode = .read_only }) catch {
    return error.FileNotFound;
  };
  defer read_file.close();

  const file_size = (read_file.stat() catch return error.StatError).size;
  var buffer = allocator.alloc(u8, file_size) catch return error.AllocatorError;
  read_file.reader().readNoEof(buffer) catch return error.ReaderError;
  
  return buffer;
}

test "read file" {
  const allocator = heap.page_allocator;

  const content: []const u8 = try readFile(allocator, "test.bf");

  try expect(@TypeOf(content) == []const u8);
  try expect(std.mem.eql(u8, content, "+++++ +++++ >>++ >>++"));
}