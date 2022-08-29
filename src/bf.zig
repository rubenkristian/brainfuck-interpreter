const std = @import("std");
const ArrayList = std.ArrayList;
const Allocator = std.mem.Allocator;

pub const Token = enum(u8) { NextPoint=1, PrevPoint=2, InValue=3, DeValue=4, Print=5, Scan=6, LoopOpen=7, LoopClose=8 };
pub const PCODE = struct {
  type: [3]u8,
  value: u32,
};

pub const Brainf = struct {
  pointer: [1024]u8,
  allocator: Allocator,
  tokens: ArrayList(Token),
  pcodes: ArrayList(PCODE),
  currLoc: u16,

  pub fn init(allocator: Allocator) !Brainf {
    return Brainf{
      .pointer = allocator.alloc(u8, 1024),
      .allocator = allocator,
      .tokens = ArrayList(Token).init(allocator),
      .pcodes = ArrayList(PCODE).init(allocator),
      .currLoc = 0,
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
    const in = std.io.getStdIn();
    var buf = std.io.bufferedReader(in.reader());

    var r = buf.reader();

    var buffer: [1]u8 = undefined;
    var char = try r.readUntilDelimiterOrEof(&buffer,'\n');

    self.pointer[self.currLoc].* = char;
  }

  fn writeBuffer(self: *Brainf) !void {
    const out = std.io.getStdOut();
    var buf = std.io.bufferedWriter(out.writer());

    var w = buf.writer();

    try w.print("{c}", .{self.pointer[self.currLoc].*});

    try buf.flush();
  }

  // change source to token before parsing
  pub fn tokenize(self: *Brainf, source: []const u8) ![]Token {
    var commentStat: bool = false;
    for (source) |ch| {
      if (ch == '+' and !commentStat) {
        try self.tokens.append(Token.InValue);
      } else if (ch == '-' and !commentStat) {
        try self.tokens.append(Token.DeValue);
      } else if (ch == '<' and !commentStat) {
        try self.tokens.append(Token.PrevPoint);
      } else if (ch == '>' and !commentStat) {
        try self.tokens.append(Token.NextPoint);
      } else if (ch == ',' and !commentStat) {
        try self.tokens.append(Token.Scan);
      } else if (ch == '.' and !commentStat) {
        try self.tokens.append(Token.Print);
      } else if (ch == '[' and !commentStat) {
        try self.tokens.append(Token.LoopOpen);
      } else if (ch == ']' and !commentStat) {
        try self.tokens.append(Token.LoopClose);
      } else if (ch == ';' and !commentStat) {
        commentStat = true;
      } else if (ch == '\n' and commentStat) {
        commentStat = false;
      } else {
        continue;
      }
    }

    return self.tokens.items;
  }

  pub fn parse(self: *Brainf) !void {
    var prevToken = undefined;
    var countToken: u16 = 0;
    var countLoop: u16 = 0;
    for (self.tokens) |token| {
      if (prevToken != undefined) {
        if (prevToken == token) {
          countToken += 1;
        } else {
          
        }
      } else {
        prevToken = token;
      }
    }
  }

  fn signPCode(count: u16, token: Token) !PCODE {
    return PCODE {
      .type=switch (token) {
        Token.InValue => "inc",
        Token.DeValue => "dec",
        Token.NextPoint => "nex",
        Token.PrevPoint => "pre",
        Token.Print => "pri",
        Token.Scan => "scn",
        Token.LoopOpen => "lop",
        Token.LoopClose => "lcl"
      },
      .value=count,
    };
  }

  pub fn Interpreter(self: *Brainf) !void {
    for (self.tokens) |token| {

    }
  }

  pub fn deinit(self: *Brainf) void{
    self.tokens.deinit();
    self.pcodes.deinit();
  }
};