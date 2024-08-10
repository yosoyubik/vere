const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});
    const t = target.result;

    const openssl = b.dependency("openssl", .{
        .target = target,
        .optimize = optimize,
    });

    const uv_c = b.dependency("uv", .{
        .target = target,
        .optimize = optimize,
    });

    const uv = b.addStaticLibrary(.{
        .name = "uv",
        .target = target,
        .optimize = optimize,
    });

    uv.linkLibC();

    uv.addIncludePath(uv_c.path("src"));
    uv.addIncludePath(uv_c.path(if (t.os.tag == .windows) "src/win" else "src/unix"));
    uv.addIncludePath(uv_c.path("include"));
    uv.addIncludePath(uv_c.path("include/uv"));

    uv.addCSourceFiles(.{
        .root = uv_c.path("src"),
        .files = if (t.os.tag == .windows) &uv_srcs_win else &uv_srcs_unix,
        .flags = &.{
            if (t.os.tag == .windows)
                "-D_WIN32"
            else
                "",
            // "-DUV_ERRNO_H_",
            // "-DE2BIG",
            "-DHAVE_STDIO_H=1",
            "-DHAVE_STDLIB_H=1",
            "-DHAVE_STRING_H=1",
            "-DHAVE_INTTYPES_H=1",
            "-DHAVE_STDINT_H=1",
            "-DHAVE_STRINGS_H=1",
            "-DHAVE_SYS_STAT_H=1",
            "-DHAVE_SYS_TYPES_H=1",
            "-DHAVE_UNISTD_H=1",
            "-DHAVE_DLFCN_H=1",
            "-DHAVE_PTHREAD_PRIO_INHERIT=1",
            "-DSTDC_HEADERS=1",
            "-DSUPPORT_ATTRIBUTE_VISIBILITY_DEFAULT=1",
            "-DSUPPORT_FLAG_VISIBILITY=1",
        },
    });

    uv.installHeader(uv_c.path("include/uv.h"), "uv.h");
    uv.installHeadersDirectory(uv_c.path("include/uv"), "", .{
        // .include_extensions = &.{".h"},
    });

    const h2o_c = b.dependency("h2o", .{
        .target = target,
        .optimize = optimize,
    });

    const h2o = b.addStaticLibrary(.{
        .name = "h2o",
        .target = target,
        .optimize = optimize,
    });

    h2o.linkLibrary(openssl.artifact("ssl"));
    h2o.linkLibrary(uv);
    h2o.linkLibC();

    h2o.addIncludePath(h2o_c.path("include"));
    h2o.addIncludePath(h2o_c.path("include/h2o"));
    h2o.addIncludePath(h2o_c.path("include/h2o/socket"));

    h2o.addCSourceFiles(.{
        .root = h2o_c.path("lib"),
        .files = &.{
            "common/cache.c",
            "common/file.c",
            "common/filecache.c",
            "common/hostinfo.c",
            "common/http1client.c",
            "common/memcached.c",
            "common/memory.c",
            "common/multithread.c",
            "common/serverutil.c",
            "common/socket.c",
            "common/socketpool.c",
            "common/string.c",
            "common/time.c",
            "common/timeout.c",
            "common/url.c",
            "core/config.c",
            "core/configurator.c",
            "core/context.c",
            "core/headers.c",
            "core/logconf.c",
            "core/proxy.c",
            "core/request.c",
            "core/token.c",
            "core/util.c",
            "handler/access_log.c",
            "handler/chunked.c",
            "handler/compress.c",
            "handler/compress/gzip.c",
            "handler/configurator/access_log.c",
            "handler/configurator/compress.c",
            "handler/configurator/errordoc.c",
            "handler/configurator/expires.c",
            "handler/configurator/fastcgi.c",
            "handler/configurator/file.c",
            "handler/configurator/headers.c",
            "handler/configurator/headers_util.c",
            "handler/configurator/http2_debug_state.c",
            "handler/configurator/proxy.c",
            "handler/configurator/redirect.c",
            "handler/configurator/reproxy.c",
            "handler/configurator/status.c",
            "handler/configurator/throttle_resp.c",
            "handler/errordoc.c",
            "handler/expires.c",
            "handler/fastcgi.c",
            "handler/file.c",
            "handler/headers.c",
            "handler/headers_util.c",
            "handler/http2_debug_state.c",
            "handler/mimemap.c",
            "handler/proxy.c",
            "handler/redirect.c",
            "handler/reproxy.c",
            "handler/status.c",
            "handler/status/durations.c",
            "handler/status/events.c",
            "handler/status/requests.c",
            "handler/throttle_resp.c",
            "http1.c",
            "http2/cache_digests.c",
            "http2/casper.c",
            "http2/connection.c",
            "http2/frame.c",
            "http2/hpack.c",
            "http2/http2_debug_state.c",
            "http2/scheduler.c",
            "http2/stream.c",
            "tunnel.c",
        },
    });

    h2o.installHeader(h2o_c.path("include/h2o.h"), "h2o.h");

    b.installArtifact(h2o);
}

const uv_srcs = [_][]const u8{
    "fs-poll.c",
    "idna.c",
    "inet.c",
    "random.c",
    "strscpy.c",
    "strtok.c",
    "threadpool.c",
    "timer.c",
    "uv-common.c",
    "uv-data-getter-setters.c",
    "version.c",
};

const uv_srcs_unix = uv_srcs ++ [_][]const u8{
    "unix/async.c",
    "unix/core.c",
    "unix/dl.c",
    "unix/fs.c",
    "unix/getaddrinfo.c",
    "unix/getnameinfo.c",
    "unix/loop-watcher.c",
    "unix/loop.c",
    "unix/pipe.c",
    "unix/poll.c",
    "unix/process.c",
    "unix/random-devurandom.c",
    "unix/signal.c",
    "unix/stream.c",
    "unix/tcp.c",
    "unix/thread.c",
    "unix/tty.c",
    "unix/udp.c",
};

const uv_srcs_win = uv_srcs ++ [_][]const u8{
    "win/async.c",
    "win/core.c",
    "win/detect-wakeup.c",
    "win/dl.c",
    "win/error.c",
    "win/fs.c",
    "win/fs-event.c",
    "win/getaddrinfo.c",
    "win/getnameinfo.c",
    "win/handle.c",
    "win/loop-watcher.c",
    "win/pipe.c",
    "win/thread.c",
    "win/poll.c",
    "win/process.c",
    "win/process-stdio.c",
    "win/signal.c",
    "win/snprintf.c",
    "win/stream.c",
    "win/tcp.c",
    "win/tty.c",
    "win/udp.c",
    "win/util.c",
    "win/winapi.c",
    "win/winsock.c",
};
