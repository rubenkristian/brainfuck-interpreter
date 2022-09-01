const std = @import("std");
const ArrayList = std.ArrayList;
const Allocator = std.mem.Allocator;
const Writer = std.io.Writer;
const BufferedWriter = std.io.BufferedWriter;

pub const Token = enum(u8) { NextPoint=1, PrevPoint=2, InValue=3, DeValue=4, Print=5, Scan=6, LoopOpen=7, LoopClose=8 };
// pub const PCODE = struct {
//   type: [3]u8,
//   value: u32,
// };

const ErrorBrain = error {
  ReaderError,
  WriterError,
};

pub const Brainf = struct {
  const out = std.io.getStdOut();
  const in = std.io.getStdIn();
  var bufAsk = std.io.bufferedWriter(out.writer());
  var bufWriter = std.io.bufferedWriter(out.writer());
  var bufReader = std.io.bufferedReader(in.reader());

  var w = bufWriter.writer();
  var r = bufReader.reader();
  var ask = bufAsk.writer();

  blocks: []u8,
  allocator: Allocator,
  tokens: ArrayList(Token),
  // pcodes: ArrayList(PCODE),
  currLoc: usize,
  stakeLoop: ArrayList(usize),

  pub fn init(allocator: Allocator) !Brainf {
    return Brainf{
      .blocks = try allocator.alloc(u8, 64),
      .allocator = allocator,
      .tokens = ArrayList(Token).init(allocator),
      .stakeLoop = ArrayList(usize).init(allocator),
      // .pcodes = ArrayList(PCODE).init(allocator),
      .currLoc = 0,
    };
  }

  fn nextPointer(self: *Brainf) ErrorBrain!void {
    if (self.currLoc < 63) {
      self.currLoc += 1;
    } else {
      self.currLoc = 0;
    }
  }

  fn prevPointer(self: *Brainf) ErrorBrain!void {
    if (self.currLoc > 0) {
      self.currLoc -= 1;
    } else {
      self.currLoc = 63;
    }
  }

  fn increaseCurrPointer(self: *Brainf) ErrorBrain!void {
    if (self.blocks[self.currLoc] < 255) {
      self.blocks[self.currLoc] += 1;
    } else {
      self.blocks[self.currLoc] = 0;
    }
  }

  fn decreaseCurrPointer(self: *Brainf) ErrorBrain!void {
    if (self.blocks[self.currLoc] > 0) {
      self.blocks[self.currLoc] -= 1;
    } else {
      self.blocks[self.currLoc] = 255;
    }
  }

  fn currPointerZero(self: *Brainf) bool {
    return self.blocks[self.currLoc] == 0;
  }

  fn input(self: *Brainf) ErrorBrain!void {
    ask.print("\rInput to block with index {} ``only take 1 character`` ", .{self.currLoc}) catch {
      return error.WriterError;
    };

    bufAsk.flush() catch {
      return error.WriterError;
    };

    var buffer: [2]u8 = undefined;
    _ = r.readUntilDelimiterOrEof(&buffer,'\n') catch {
      return error.ReaderError;
    };

    self.blocks[self.currLoc] = buffer[0];
  }

  fn writeBuffer(self: *Brainf) ErrorBrain!void {
    w.print("{c}", .{self.blocks[self.currLoc]}) catch {
      return error.WriterError;
    };
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

  // must check
  // after allocation, value in
  pub fn reset(self: *Brainf) void {
    for(self.blocks) |_, index| {
      self.blocks[index] = 0;
    }
  }

  // pub fn parse(self: *Brainf) !void {
  //   var prevToken = undefined;
  //   var countToken: u16 = 0;
  //   var countLoop: u16 = 0;
  //   for (self.tokens) |token| {
  //     if (prevToken != undefined) {
  //       if (prevToken == token) {
  //         countToken += 1;
  //       } else {
          
  //       }
  //     } else {
  //       prevToken = token;
  //     }
  //   }
  // }

  // fn signPCode(count: u16, token: Token) !PCODE {
  //   return PCODE {
  //     .type=switch (token) {
  //       Token.InValue => "inc",
  //       Token.DeValue => "dec",
  //       Token.NextPoint => "nex",
  //       Token.PrevPoint => "pre",
  //       Token.Print => "pri",
  //       Token.Scan => "scn",
  //       Token.LoopOpen => "lop",
  //       Token.LoopClose => "lcl"
  //     },
  //     .value=count,
  //   };
  // }

  pub fn Interpreter(self: *Brainf) !void {
    const maxRows = self.tokens.items.len;
    var index:usize = 0;
    while (index < maxRows) {
      const token = self.tokens.items[index];
      
      _ = switch (token) {
        .InValue => self.increaseCurrPointer(),
        .DeValue => self.decreaseCurrPointer(),
        .NextPoint => self.nextPointer(),
        .PrevPoint => self.prevPointer(),
        .Print => self.writeBuffer(),
        .Scan => self.input(),
        .LoopOpen => self.stakeLoop.append(index),
        .LoopClose => {
          if (self.currPointerZero()) {
            _ = self.stakeLoop.pop();
            index += 1;
          } else {
            index = self.stakeLoop.pop();
          }
        },
      } catch {
        std.log.err("Interpreter interrupted", .{});
        return;
      };

      if (token != Token.LoopClose) {
        index += 1;
      }
    }

    try w.print("\r\n", .{});

    try bufWriter.flush();
  }

  pub fn deinit(self: *Brainf) void{
    self.tokens.deinit();
    self.stakeLoop.deinit();
    self.allocator.free(self.blocks);
    // self.pcodes.deinit();
  }
};