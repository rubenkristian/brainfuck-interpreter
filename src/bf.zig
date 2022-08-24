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

  pub fn tokenize(self: *Brainf) !void {
    
  }

  pub fn parse(self: *Brainf, source: []const u8) !void {

  }

  pub fn Interpreter(self: *Brainf) !void {

  }
};