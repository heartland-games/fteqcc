const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const zlib_dep = b.dependency("zlib", .{
        .optimize = optimize,
        .target = target,
    });

    // const vm = b.addExecutable(.{
    //     .name = "qcvm",
    //     .target = target,
    //     .optimize = optimize,
    // });
    // vm.linkLibC();
    // vm.addCSourceFiles(.{
    //     .files = &qcc_sources ++ &vm_sources ++ &common_sources,
    //     .flags = &cflags,
    // });
    // b.installArtifact(vm);
    //
    // vm.linkLibrary(zlib_dep.artifact("zlib"));
    // vm.addIncludePath(zlib_dep.path(""));

    const exe = b.addExecutable(.{
        .name = "fteqcc",
        .target = target,
        .optimize = optimize,
    });
    exe.subsystem = .Console;

    exe.addWin32ResourceFile(.{ .file = .{ .path = "fteqcc.rc" } });

    exe.linkLibC();
    exe.addCSourceFiles(.{
        .files = &common_sources ++ &qcc_sources ++ &tui_sources,
        .flags = &cflags,
    });

    exe.linkLibrary(zlib_dep.artifact("zlib"));
    exe.addIncludePath(zlib_dep.path(""));

    b.installArtifact(exe);
    const run_cmd = b.addRunArtifact(exe);
    run_cmd.step.dependOn(b.getInstallStep());
    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);
}

const cflags = [_][]const u8{
    "-Wno-pointer-sign",
    "-Wall",
};

const common_sources = [_][]const u8{
    "comprout.c",
    "hash.c",
    "qcc_cmdlib.c",
    "qcd_main.c",
};
const qcc_sources = [_][]const u8{
    "qccmain.c",
    "qcc_pr_comp.c",
    "qcc_pr_lex.c",
};
const vm_sources = [_][]const u8{
    "pr_exec.c",
    "pr_edict.c",
    "pr_multi.c",
    "initlib.c",
    "qcdecomp.c",
};
const tui_sources = [_][]const u8{
    "qcctui.c",
    "packager.c",
};
