const std = @import("std");
const Allocator = std.mem.Allocator;

const TOKEN = enum { NextPoint, PrevPoint, InValue, DeValue, Print, Scan, LoopOpen, LoopClose };

pub const Brainf = struct {

  pub const pointer: [100]u8;
  pub var val: u8;
  var tree: []TOKEN;

  pub fn init(allocator: Allocator) !void {
    
  }

  pub fn deinit(self: *Brainf) !void {

  }

  // change source to token before parsing
  pub fn tokenize(self: *Brainf, source: []const u8) ![]TOKEN {
    for (source) |_, ch| {
      switch (ch) {
        // '+', '-', '>', '<', ',', '.', '[', ']' => 8,
        // else => continue
      }
    }
  }

  pub fn parse(self: *Brainf, token: []TOKEN) !void {
    switch (token) {
      TOKEN.NextPoint => return,
      TOKEN.PrevPoint => return,
      TOKEN.InValue => return,
      TOKEN.DeValue => return,
      TOKEN.Print => return,
      TOKEN.Scan => return,
      TOKEN.LoopClose => return,
      TOKEN.LoopOpen => return,
      else => continue,
    }
  }

  pub fn Interpreter(self: *Brainf) !void {
    
  }
};