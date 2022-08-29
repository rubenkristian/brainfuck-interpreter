const std = @import("std");

pub fn build(b: *std.build.Builder) void {
    // Standard target options allows the person running `zig build` to choose
    // what target to build for. Here we do not override the defaults, which
    // means any target is allowed, and the default is native. Other options
    // for restricting supported target set are available.
    const target = b.standardTargetOptions(.{});

    // Standard release options allow the person running `zig build` to select
    // between Debug, ReleaseSafe, ReleaseFast, and ReleaseSmall.
    const mode = b.standardReleaseOptions();

    const brainf = b.addExecutable("brainf", "src/main.zig");
    brainf.setTarget(target);
    brainf.setBuildMode(mode);
    brainf.install();

    // const brainfuck = b.addExecutable("brainfuck", "src/main.zig");
    // brainfuck.setTarget(target);
    // brainfuck.setBuildMode(mode);
    // brainfuck.install();

    const run_brainf = brainf.run();
    run_brainf.step.dependOn(b.getInstallStep());

    // const run_brainfuck = brainfuck.run();
    // run_brainfuck.step.dependOn(b.getInstallStep());

    if (b.args) |args| {
        run_brainf.addArgs(args);
        // run_brainfuck.addArgs(args);
    }

    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_brainf.step);
    // run_step.dependOn(&run_brainfuck.step);

    const exe_tests = b.addTest("src/main.zig");
    exe_tests.setTarget(target);
    exe_tests.setBuildMode(mode);

    const test_step = b.step("test", "Run unit tests");
    test_step.dependOn(&exe_tests.step);
}
