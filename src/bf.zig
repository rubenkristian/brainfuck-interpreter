const std = @import("std");
const Allocator = std.mem.Allocator;

const TOKEN = enum { NextPoint, PrevPoint, InValue, DeValue, Print, Scan, LoopOpen, LoopClose };

pub const Brainf = struct {
  pointer: [1024]u8,
  allocator: Allocator,
  currLoc: u16 = 0,

  pub fn init(allocator: Allocator) !Brainf {
    return Brainf{
      .pointer = allocator.alloc(u8, 1024),
    };
  }

  fn nextPointer(self: *Brainf) !void {
    self.currLoc += 1;
  }

  fn prevPointer(self: *Brainf) !void {
    self.currLoc -= 1;
  }

  fn increaseCurrPointer(self: *Brainf) !void {
    self.pointer[self.currLoc].* += 1;
  }

  fn decreaseCurrPointer(self: *Brainf) !void {
    self.pointer[self.currLoc].* -= 1;
  }

  fn input(self: *Brainf) !void {

  }

  fn writeBuffer(self: *Brainf) !void {
    
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