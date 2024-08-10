const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});
    const t = target.result;

    const dep_c = b.dependency("gmp", .{
        .target = target,
        .optimize = optimize,
    });

    const gen_srcs = b.dependency("gen_srcs", .{
        .target = target,
        .optimize = optimize,
    });

    const lib = b.addStaticLibrary(.{
        .name = "gmp",
        .target = target,
        .optimize = optimize,
    });

    lib.linkLibC();

    // TODO: Verify these
    const config_h = b.addConfigHeader(.{
        .style = .{
            .autoconf = dep_c.path("config.in"),
        },
        .include_path = "config.h",
    }, .{
        .GMP_MPARAM_H_SUGGEST = "./mpn/arm64/gmp-mparam.h",
        .HAVE_ALARM = 1,
        .HAVE_ALLOCA = 1,
        .HAVE_ALLOCA_H = 1,
        .HAVE_ATTRIBUTE_CONST = 1,
        .HAVE_ATTRIBUTE_MALLOC = 1,
        .HAVE_ATTRIBUTE_MODE = 1,
        .HAVE_ATTRIBUTE_NORETURN = 1,
        .HAVE_CLOCK = 1,
        .HAVE_CLOCK_GETTIME = 1,
        .HAVE_DECL_FGETC = 1,
        .HAVE_DECL_FSCANF = 1,
        .HAVE_DECL_OPTARG = 1,
        .HAVE_DECL_SYS_ERRLIST = 1,
        .HAVE_DECL_SYS_NERR = 1,
        .HAVE_DECL_UNGETC = 1,
        .HAVE_DECL_VFPRINTF = 1,
        .HAVE_DLFCN_H = 1,
        .HAVE_DOUBLE_IEEE_LITTLE_ENDIAN = 1,
        .HAVE_FCNTL_H = 1,
        .HAVE_FLOAT_H = 1,
        .HAVE_GETPAGESIZE = 1,
        .HAVE_GETRUSAGE = 1,
        .HAVE_GETTIMEOFDAY = 1,
        .HAVE_INTMAX_T = 1,
        .HAVE_INTPTR_T = 1,
        .HAVE_INTTYPES_H = 1,
        .HAVE_LANGINFO_H = 1,
        .HAVE_LIMB_LITTLE_ENDIAN = 1,
        .HAVE_LOCALECONV = 1,
        .HAVE_LOCALE_H = 1,
        .HAVE_LONG_DOUBLE = 1,
        .HAVE_LONG_LONG = 1,
        .HAVE_MEMORY_H = 1,
        .HAVE_MEMSET = 1,
        .HAVE_MMAP = 1,
        .HAVE_MPROTECT = 1,
        .HAVE_NATIVE_mpn_add_n = 1,
        .HAVE_NATIVE_mpn_add_nc = 1,
        .HAVE_NATIVE_mpn_addlsh1_n = 1,
        .HAVE_NATIVE_mpn_addlsh2_n = 1,
        .HAVE_NATIVE_mpn_and_n = 1,
        .HAVE_NATIVE_mpn_andn_n = 1,
        .HAVE_NATIVE_mpn_bdiv_dbm1c = 1,
        .HAVE_NATIVE_mpn_bdiv_q_1 = 1,
        .HAVE_NATIVE_mpn_pi1_bdiv_q_1 = 1,
        .HAVE_NATIVE_mpn_cnd_add_n = 1,
        .HAVE_NATIVE_mpn_cnd_sub_n = 1,
        .HAVE_NATIVE_mpn_com = 1,
        .HAVE_NATIVE_mpn_copyd = 1,
        .HAVE_NATIVE_mpn_copyi = 1,
        .HAVE_NATIVE_mpn_gcd_11 = 1,
        .HAVE_NATIVE_mpn_gcd_22 = 1,
        .HAVE_NATIVE_mpn_hamdist = 1,
        .HAVE_NATIVE_mpn_invert_limb = 1,
        .HAVE_NATIVE_mpn_ior_n = 1,
        .HAVE_NATIVE_mpn_iorn_n = 1,
        .HAVE_NATIVE_mpn_lshift = 1,
        .HAVE_NATIVE_mpn_lshiftc = 1,
        .HAVE_NATIVE_mpn_mod_34lsub1 = 1,
        .HAVE_NATIVE_mpn_mul_1 = 1,
        .HAVE_NATIVE_mpn_mul_1c = 1,
        .HAVE_NATIVE_mpn_nand_n = 1,
        .HAVE_NATIVE_mpn_nior_n = 1,
        .HAVE_NATIVE_mpn_popcount = 1,
        .HAVE_NATIVE_mpn_rsblsh1_n = 1,
        .HAVE_NATIVE_mpn_rsblsh2_n = 1,
        .HAVE_NATIVE_mpn_rsh1add_n = 1,
        .HAVE_NATIVE_mpn_rsh1sub_n = 1,
        .HAVE_NATIVE_mpn_rshift = 1,
        .HAVE_NATIVE_mpn_sqr_diag_addlsh1 = 1,
        .HAVE_NATIVE_mpn_sub_n = 1,
        .HAVE_NATIVE_mpn_sub_nc = 1,
        .HAVE_NATIVE_mpn_sublsh1_n = 1,
        .HAVE_NATIVE_mpn_sublsh2_n = 1,
        .HAVE_NATIVE_mpn_xor_n = 1,
        .HAVE_NATIVE_mpn_xnor_n = 1,
        .HAVE_NL_LANGINFO = 1,
        .HAVE_NL_TYPES_H = 1,
        .HAVE_POPEN = 1,
        .HAVE_PROCESSOR_INFO = 1,
        .HAVE_PTRDIFF_T = 1,
        .HAVE_QUAD_T = 1,
        .HAVE_RAISE = 1,
        .HAVE_SIGACTION = 1,
        .HAVE_SIGALTSTACK = 1,
        .HAVE_STACK_T = 1,
        .HAVE_STDINT_H = 1,
        .HAVE_STDLIB_H = 1,
        .HAVE_STRCHR = 1,
        .HAVE_STRERROR = 1,
        .HAVE_STRINGS_H = 1,
        .HAVE_STRING_H = 1,
        .HAVE_STRNLEN = 1,
        .HAVE_STRTOL = 1,
        .HAVE_STRTOUL = 1,
        .HAVE_SYSCONF = 1,
        .HAVE_SYSCTL = 1,
        .HAVE_SYSCTLBYNAME = 1,
        .HAVE_SYS_MMAN_H = 1,
        .HAVE_SYS_PARAM_H = 1,
        .HAVE_SYS_RESOURCE_H = 1,
        .HAVE_SYS_STAT_H = 1,
        .HAVE_SYS_SYSCTL_H = 1,
        .HAVE_SYS_TIMES_H = 1,
        .HAVE_SYS_TIME_H = 1,
        .HAVE_SYS_TYPES_H = 1,
        .HAVE_TIMES = 1,
        .HAVE_UINT_LEAST32_T = 1,
        .HAVE_UNISTD_H = 1,
        .HAVE_VSNPRINTF = 1,
        .LSYM_PREFIX = "L",
        .LT_OBJDIR = ".libs/",
        .PACKAGE = "gmp",
        .PACKAGE_BUGREPORT = "gmp-bugs@gmplib.org, see https://gmplib.org/manual/Reporting-Bugs.html",
        .PACKAGE_NAME = "GNU MP",
        .PACKAGE_STRING = "GNU MP 6.2.1",
        .PACKAGE_TARNAME = "gmp",
        .PACKAGE_URL = "http://www.gnu.org/software/gmp/",
        .PACKAGE_VERSION = "6.2.1",
        .RETSIGTYPE = null,
        .SIZEOF_MP_LIMB_T = 8,
        .SIZEOF_UNSIGNED = 4,
        .SIZEOF_UNSIGNED_LONG = 8,
        .SIZEOF_UNSIGNED_SHORT = 2,
        .SIZEOF_VOID_P = 8,
        .STDC_HEADERS = 1,
        .TIME_WITH_SYS_TIME = 1,
        .TUNE_SQR_TOOM2_MAX = "SQR_TOOM2_MAX_GENERIC",
        .VERSION = "6.2.1",
        .WANT_FFT = 1,
        .WANT_TMP_ALLOCA = 1,
        .YYTEXT_POINTER = 1,
        .restrict = .__restrict,
        .AC_APPLE_UNIVERSAL_BUILD = null,
        .HAVE_ATTR_GET = null,
        .HAVE_CALLING_CONVENTIONS = null,
        .HAVE_CPUTIME = null,
        .HAVE_DOUBLE_IEEE_BIG_ENDIAN = null,
        .HAVE_DOUBLE_IEEE_LITTLE_SWAPPED = null,
        .HAVE_DOUBLE_VAX_D = null,
        .HAVE_DOUBLE_VAX_G = null,
        .HAVE_DOUBLE_CRAY_CFP = null,
        .HAVE_GETSYSINFO = null,
        .HAVE_HIDDEN_ALIAS = null,
        .HAVE_HOST_CPU_FAMILY_alpha = null,
        .HAVE_HOST_CPU_FAMILY_m68k = null,
        .HAVE_HOST_CPU_FAMILY_power = null,
        .HAVE_HOST_CPU_FAMILY_powerpc = null,
        .HAVE_HOST_CPU_FAMILY_x86 = null,
        .HAVE_HOST_CPU_FAMILY_x86_64 = null,
        .HAVE_HOST_CPU_alphaev67 = null,
        .HAVE_HOST_CPU_alphaev68 = null,
        .HAVE_HOST_CPU_alphaev7 = null,
        .HAVE_HOST_CPU_m68020 = null,
        .HAVE_HOST_CPU_m68030 = null,
        .HAVE_HOST_CPU_m68040 = null,
        .HAVE_HOST_CPU_m68060 = null,
        .HAVE_HOST_CPU_m68360 = null,
        .HAVE_HOST_CPU_powerpc604 = null,
        .HAVE_HOST_CPU_powerpc604e = null,
        .HAVE_HOST_CPU_powerpc750 = null,
        .HAVE_HOST_CPU_powerpc7400 = null,
        .HAVE_HOST_CPU_supersparc = null,
        .HAVE_HOST_CPU_i386 = null,
        .HAVE_HOST_CPU_i586 = null,
        .HAVE_HOST_CPU_i686 = null,
        .HAVE_HOST_CPU_pentium = null,
        .HAVE_HOST_CPU_pentiummmx = null,
        .HAVE_HOST_CPU_pentiumpro = null,
        .HAVE_HOST_CPU_pentium2 = null,
        .HAVE_HOST_CPU_pentium3 = null,
        .HAVE_HOST_CPU_pentium4 = null,
        .HAVE_HOST_CPU_core2 = null,
        .HAVE_HOST_CPU_nehalem = null,
        .HAVE_HOST_CPU_westmere = null,
        .HAVE_HOST_CPU_sandybridge = null,
        .HAVE_HOST_CPU_ivybridge = null,
        .HAVE_HOST_CPU_haswell = null,
        .HAVE_HOST_CPU_broadwell = null,
        .HAVE_HOST_CPU_skylake = null,
        .HAVE_HOST_CPU_silvermont = null,
        .HAVE_HOST_CPU_goldmont = null,
        .HAVE_HOST_CPU_k8 = null,
        .HAVE_HOST_CPU_k10 = null,
        .HAVE_HOST_CPU_bulldozer = null,
        .HAVE_HOST_CPU_piledriver = null,
        .HAVE_HOST_CPU_steamroller = null,
        .HAVE_HOST_CPU_excavator = null,
        .HAVE_HOST_CPU_zen = null,
        .HAVE_HOST_CPU_bobcat = null,
        .HAVE_HOST_CPU_jaguar = null,
        .HAVE_HOST_CPU_s390_z900 = null,
        .HAVE_HOST_CPU_s390_z990 = null,
        .HAVE_HOST_CPU_s390_z9 = null,
        .HAVE_HOST_CPU_s390_z10 = null,
        .HAVE_HOST_CPU_s390_z196 = null,
        .HAVE_HOST_CPU_s390_zarch = null,
        .HAVE_INVENT_H = null,
        .HAVE_LIMB_BIG_ENDIAN = null,
        .HAVE_MACHINE_HAL_SYSINFO_H = null,
        .HAVE_NATIVE_mpn_add_n_sub_n = null,
        .HAVE_NATIVE_mpn_addaddmul_1msb0 = null,
        .HAVE_NATIVE_mpn_addlsh_n = null,
        .HAVE_NATIVE_mpn_addlsh1_nc = null,
        .HAVE_NATIVE_mpn_addlsh2_nc = null,
        .HAVE_NATIVE_mpn_addlsh_nc = null,
        .HAVE_NATIVE_mpn_addlsh1_n_ip1 = null,
        .HAVE_NATIVE_mpn_addlsh2_n_ip1 = null,
        .HAVE_NATIVE_mpn_addlsh_n_ip1 = null,
        .HAVE_NATIVE_mpn_addlsh1_nc_ip1 = null,
        .HAVE_NATIVE_mpn_addlsh2_nc_ip1 = null,
        .HAVE_NATIVE_mpn_addlsh_nc_ip1 = null,
        .HAVE_NATIVE_mpn_addlsh1_n_ip2 = null,
        .HAVE_NATIVE_mpn_addlsh2_n_ip2 = null,
        .HAVE_NATIVE_mpn_addlsh_n_ip2 = null,
        .HAVE_NATIVE_mpn_addlsh1_nc_ip2 = null,
        .HAVE_NATIVE_mpn_addlsh2_nc_ip2 = null,
        .HAVE_NATIVE_mpn_addlsh_nc_ip2 = null,
        .HAVE_NATIVE_mpn_addmul_1c = null,
        .HAVE_NATIVE_mpn_addmul_2 = null,
        .HAVE_NATIVE_mpn_addmul_3 = null,
        .HAVE_NATIVE_mpn_addmul_4 = null,
        .HAVE_NATIVE_mpn_addmul_5 = null,
        .HAVE_NATIVE_mpn_addmul_6 = null,
        .HAVE_NATIVE_mpn_addmul_7 = null,
        .HAVE_NATIVE_mpn_addmul_8 = null,
        .HAVE_NATIVE_mpn_addmul_2s = null,
        .HAVE_NATIVE_mpn_div_qr_1n_pi1 = null,
        .HAVE_NATIVE_mpn_div_qr_2 = null,
        .HAVE_NATIVE_mpn_divexact_1 = null,
        .HAVE_NATIVE_mpn_divexact_by3c = null,
        .HAVE_NATIVE_mpn_divrem_1 = null,
        .HAVE_NATIVE_mpn_divrem_1c = null,
        .HAVE_NATIVE_mpn_divrem_2 = null,
        .HAVE_NATIVE_mpn_gcd_1 = null,
        .HAVE_NATIVE_mpn_lshsub_n = null,
        .HAVE_NATIVE_mpn_mod_1 = null,
        .HAVE_NATIVE_mpn_mod_1_1p = null,
        .HAVE_NATIVE_mpn_mod_1c = null,
        .HAVE_NATIVE_mpn_mod_1s_2p = null,
        .HAVE_NATIVE_mpn_mod_1s_4p = null,
        .HAVE_NATIVE_mpn_modexact_1_odd = null,
        .HAVE_NATIVE_mpn_modexact_1c_odd = null,
        .HAVE_NATIVE_mpn_mul_2 = null,
        .HAVE_NATIVE_mpn_mul_3 = null,
        .HAVE_NATIVE_mpn_mul_4 = null,
        .HAVE_NATIVE_mpn_mul_5 = null,
        .HAVE_NATIVE_mpn_mul_6 = null,
        .HAVE_NATIVE_mpn_mul_basecase = null,
        .HAVE_NATIVE_mpn_mullo_basecase = null,
        .HAVE_NATIVE_mpn_preinv_divrem_1 = null,
        .HAVE_NATIVE_mpn_preinv_mod_1 = null,
        .HAVE_NATIVE_mpn_redc_1 = null,
        .HAVE_NATIVE_mpn_redc_2 = null,
        .HAVE_NATIVE_mpn_rsblsh_n = null,
        .HAVE_NATIVE_mpn_rsblsh1_nc = null,
        .HAVE_NATIVE_mpn_rsblsh2_nc = null,
        .HAVE_NATIVE_mpn_rsblsh_nc = null,
        .HAVE_NATIVE_mpn_rsh1add_nc = null,
        .HAVE_NATIVE_mpn_rsh1sub_nc = null,
        .HAVE_NATIVE_mpn_sbpi1_bdiv_r = null,
        .HAVE_NATIVE_mpn_sqr_basecase = null,
        .HAVE_NATIVE_mpn_sqr_diagonal = null,
        .HAVE_NATIVE_mpn_sublsh_n = null,
        .HAVE_NATIVE_mpn_sublsh1_nc = null,
        .HAVE_NATIVE_mpn_sublsh2_nc = null,
        .HAVE_NATIVE_mpn_sublsh_nc = null,
        .HAVE_NATIVE_mpn_sublsh1_n_ip1 = null,
        .HAVE_NATIVE_mpn_sublsh2_n_ip1 = null,
        .HAVE_NATIVE_mpn_sublsh_n_ip1 = null,
        .HAVE_NATIVE_mpn_sublsh1_nc_ip1 = null,
        .HAVE_NATIVE_mpn_sublsh2_nc_ip1 = null,
        .HAVE_NATIVE_mpn_sublsh_nc_ip1 = null,
        .HAVE_NATIVE_mpn_submul_1c = null,
        .HAVE_NATIVE_mpn_tabselect = null,
        .HAVE_NATIVE_mpn_udiv_qrnnd = null,
        .HAVE_NATIVE_mpn_udiv_qrnnd_r = null,
        .HAVE_NATIVE_mpn_umul_ppmm = null,
        .HAVE_NATIVE_mpn_umul_ppmm_r = null,
        .HAVE_OBSTACK_VPRINTF = null,
        .HAVE_PSP_ITICKSPERCLKTICK = null,
        .HAVE_PSTAT_GETPROCESSOR = null,
        .HAVE_READ_REAL_TIME = null,
        .HAVE_SIGSTACK = null,
        .HAVE_SPEED_CYCLECOUNTER = null,
        .HAVE_SSTREAM = null,
        .HAVE_STD__LOCALE = null,
        .HAVE_SYSSGI = null,
        .HAVE_SYS_ATTRIBUTES_H = null,
        .HAVE_SYS_IOGRAPH_H = null,
        .HAVE_SYS_PROCESSOR_H = null,
        .HAVE_SYS_PSTAT_H = null,
        .HAVE_SYS_SYSINFO_H = null,
        .HAVE_SYS_SYSSGI_H = null,
        .HAVE_SYS_SYSTEMCFG_H = null,
        .HOST_DOS64 = null,
        .NO_ASM = null,
        .SSCANF_WRITABLE_INPUT = null,
        .WANT_ASSERT = null,
        .WANT_FAKE_CPUID = null,
        .WANT_FAT_BINARY = null,
        .WANT_OLD_FFT_FULL = null,
        .WANT_PROFILING_GPROF = null,
        .WANT_PROFILING_INSTRUMENT = null,
        .WANT_PROFILING_PROF = null,
        .WANT_TMP_REENTRANT = null,
        .WANT_TMP_NOTREENTRANT = null,
        .WANT_TMP_DEBUG = null,
        .WORDS_BIGENDIAN = null,
        .X86_ASM_MULX = null,
        .@"inline" = null,
        .@"volatile" = null,
    });

    // TODO: Finish this
    const gmp_h = b.addConfigHeader(.{
        .style = .{
            .cmake = dep_c.path("gmp-h.in"),
        },
        .include_path = "gmp.h",
    }, .{
        .HAVE_HOST_CPU_FAMILY_power = 0,
        .HAVE_HOST_CPU_FAMILY_powerpc = 0,
        .GMP_LIMB_BITS = 64,
        .GMP_NAIL_BITS = 0,
        .DEFN_LONG_LONG_LIMB = "",
        .LIBGMP_DLL = 0,
        .CC = "gcc",
        .CFLAGS = "-O2 -pedantic -march=armv8-a",
    });

    lib.addConfigHeader(config_h);
    lib.addConfigHeader(gmp_h);

    // Generated headers
    if (t.cpu.arch.isAARCH64()) {
        lib.addIncludePath(gen_srcs.path("aarch64"));
        lib.addIncludePath(gen_srcs.path("aarch64/mpn"));
    } else if (t.cpu.arch.isX86()) {
        lib.addIncludePath(gen_srcs.path("x86_64"));
        lib.addIncludePath(gen_srcs.path("x86_64/mpn"));
    }

    // Static headers
    lib.addIncludePath(dep_c.path("."));
    lib.addIncludePath(dep_c.path("mpf"));
    lib.addIncludePath(dep_c.path("mpn"));
    lib.addIncludePath(dep_c.path("mpq"));
    lib.addIncludePath(dep_c.path("mpz"));
    lib.addIncludePath(dep_c.path("printf"));
    lib.addIncludePath(dep_c.path("rand"));
    lib.addIncludePath(dep_c.path("scanf"));
    if (t.cpu.arch.isAARCH64()) {
        lib.addIncludePath(dep_c.path("mpn/arm64"));
    } else if (t.cpu.arch.isX86()) {
        lib.addIncludePath(dep_c.path("mpn/x86_64"));
    }

    // Translated ASM Sources
    if (t.cpu.arch.isAARCH64()) {
        for (aarch64_asm_sources) |rel_path| {
            lib.addAssemblyFile(gen_srcs.path(rel_path));
        }
    } else if (t.cpu.arch.isX86()) {
        for (x86_64_asm_sources) |rel_path| {
            lib.addAssemblyFile(gen_srcs.path(rel_path));
        }
    }

    // Generated C Sources
    if (t.cpu.arch.isAARCH64()) {
        lib.addCSourceFiles(.{
            .root = gen_srcs.path("aarch64"),
            .files = &.{
                "mpn/mp_bases.c",
                "mpn/fib_table.c",
            },
            .flags = &.{},
        });
    } else if (t.cpu.arch.isX86()) {
        lib.addCSourceFiles(.{
            .root = gen_srcs.path("x86_64"),
            .files = &.{
                "mpn/mp_bases.c",
                "mpn/fib_table.c",
            },
            .flags = &.{},
        });
    }

    // Generic C Sources
    lib.addCSourceFiles(.{
        .root = dep_c.path(""),
        .files = &generic_c_sources,
        .flags = &.{},
    });

    // These files need to be compiles twice with different macros
    lib.addCSourceFiles(.{
        .root = dep_c.path(""),
        .files = &.{
            "mpn/generic/sec_div.c",
            "mpn/generic/sec_pi1_div.c",
            "mpn/generic/sec_aors_1.c",
        },
        .flags = &.{
            "-DOPERATION_sec_div_qr", // sec_div.c
            "-DOPERATION_sec_pi1_div_qr", // sec_pi1_div.c
            "-DOPERATION_sec_add_1", // sec_aors_1.c
        },
    });
    lib.addCSourceFiles(.{
        .root = dep_c.path(""),
        .files = &.{
            "mpn/generic/sec_div.c",
            "mpn/generic/sec_pi1_div.c",
            "mpn/generic/sec_aors_1.c",
        },
        .flags = &.{
            "-DOPERATION_sec_div_r", // sec_div.c
            "-DOPERATION_sec_pi1_div_r", // sec_pi1_div.c
            "-DOPERATION_sec_sub_1", // sec_aors_1.c
        },
    });

    lib.installConfigHeader(gmp_h);

    b.installArtifact(lib);
}

const aarch64_asm_sources = [_][]const u8{
    "aarch64/mpn/add_n.s",
    "aarch64/mpn/addlsh1_n.s",
    "aarch64/mpn/addlsh2_n.s",
    "aarch64/mpn/addmul_1.s",
    "aarch64/mpn/and_n.s",
    "aarch64/mpn/andn_n.s",
    "aarch64/mpn/bdiv_dbm1c.s",
    "aarch64/mpn/bdiv_q_1.s",
    "aarch64/mpn/cnd_add_n.s",
    "aarch64/mpn/cnd_sub_n.s",
    "aarch64/mpn/com.s",
    "aarch64/mpn/copyd.s",
    "aarch64/mpn/copyi.s",
    "aarch64/mpn/gcd_11.s",
    "aarch64/mpn/gcd_22.s",
    "aarch64/mpn/hamdist.s",
    "aarch64/mpn/invert_limb.s",
    "aarch64/mpn/ior_n.s",
    "aarch64/mpn/iorn_n.s",
    "aarch64/mpn/lshift.s",
    "aarch64/mpn/lshiftc.s",
    "aarch64/mpn/mod_34lsub1.s",
    "aarch64/mpn/mul_1.s",
    "aarch64/mpn/nand_n.s",
    "aarch64/mpn/nior_n.s",
    "aarch64/mpn/popcount.s",
    "aarch64/mpn/rsblsh1_n.s",
    "aarch64/mpn/rsblsh2_n.s",
    "aarch64/mpn/rsh1add_n.s",
    "aarch64/mpn/rsh1sub_n.s",
    "aarch64/mpn/rshift.s",
    "aarch64/mpn/sec_tabselect.s",
    "aarch64/mpn/sqr_diag_addlsh1.s",
    "aarch64/mpn/sub_n.s",
    "aarch64/mpn/sublsh1_n.s",
    "aarch64/mpn/sublsh2_n.s",
    "aarch64/mpn/submul_1.s",
    "aarch64/mpn/xnor_n.s",
    "aarch64/mpn/xor_n.s",
};

const x86_64_asm_sources = [_][]const u8{
    "x86_64/mpn/add_err1_n.s",
    "x86_64/mpn/add_err2_n.s",
    "x86_64/mpn/add_err3_n.s",
    "x86_64/mpn/add_n.s",
    "x86_64/mpn/addaddmul_1msb0.s",
    "x86_64/mpn/addlsh1_n.s",
    "x86_64/mpn/addlsh2_n.s",
    "x86_64/mpn/addlsh_n.s",
    "x86_64/mpn/addmul_1.s",
    "x86_64/mpn/addmul_2.s",
    "x86_64/mpn/and_n.s",
    "x86_64/mpn/andn_n.s",
    "x86_64/mpn/bdiv_dbm1c.s",
    "x86_64/mpn/bdiv_q_1.s",
    "x86_64/mpn/cnd_add_n.s",
    "x86_64/mpn/cnd_sub_n.s",
    "x86_64/mpn/com.s",
    "x86_64/mpn/copyd.s",
    "x86_64/mpn/copyi.s",
    "x86_64/mpn/div_qr_1n_pi1.s",
    "x86_64/mpn/div_qr_2n_pi1.s",
    "x86_64/mpn/div_qr_2u_pi1.s",
    "x86_64/mpn/dive_1.s",
    "x86_64/mpn/divrem_1.s",
    "x86_64/mpn/divrem_2.s",
    "x86_64/mpn/gcd_11.s",
    "x86_64/mpn/gcd_22.s",
    "x86_64/mpn/hamdist.s",
    "x86_64/mpn/invert_limb.s",
    "x86_64/mpn/invert_limb_table.s",
    "x86_64/mpn/ior_n.s",
    "x86_64/mpn/iorn_n.s",
    "x86_64/mpn/lshift.s",
    "x86_64/mpn/lshiftc.s",
    "x86_64/mpn/mod_1_1.s",
    "x86_64/mpn/mod_1_2.s",
    "x86_64/mpn/mod_1_4.s",
    "x86_64/mpn/mod_34lsub1.s",
    "x86_64/mpn/mode1o.s",
    "x86_64/mpn/mul_1.s",
    "x86_64/mpn/mul_2.s",
    "x86_64/mpn/mul_basecase.s",
    "x86_64/mpn/mullo_basecase.s",
    "x86_64/mpn/nand_n.s",
    "x86_64/mpn/nior_n.s",
    "x86_64/mpn/popcount.s",
    "x86_64/mpn/redc_1.s",
    "x86_64/mpn/rsblsh1_n.s",
    "x86_64/mpn/rsblsh2_n.s",
    "x86_64/mpn/rsblsh_n.s",
    "x86_64/mpn/rsh1add_n.s",
    "x86_64/mpn/rsh1sub_n.s",
    "x86_64/mpn/rshift.s",
    "x86_64/mpn/sec_tabselect.s",
    "x86_64/mpn/sqr_basecase.s",
    "x86_64/mpn/sqr_diag_addlsh1.s",
    "x86_64/mpn/sub_err1_n.s",
    "x86_64/mpn/sub_err2_n.s",
    "x86_64/mpn/sub_err3_n.s",
    "x86_64/mpn/sub_n.s",
    "x86_64/mpn/sublsh1_n.s",
    "x86_64/mpn/sublsh2_n.s",
    "x86_64/mpn/submul_1.s",
    "x86_64/mpn/xnor_n.s",
    "x86_64/mpn/xor_n.s",
};

const generic_c_sources = [_][]const u8{
    "mpf/abs.c",
    "mpf/add.c",
    "mpf/add_ui.c",
    "mpf/ceilfloor.c",
    "mpf/clear.c",
    "mpf/clears.c",
    "mpf/cmp.c",
    "mpf/cmp_d.c",
    "mpf/cmp_si.c",
    "mpf/cmp_ui.c",
    "mpf/cmp_z.c",
    "mpf/div.c",
    "mpf/div_2exp.c",
    "mpf/div_ui.c",
    "mpf/dump.c",
    "mpf/eq.c",
    "mpf/fits_sint.c",
    "mpf/fits_slong.c",
    "mpf/fits_sshort.c",
    "mpf/fits_uint.c",
    "mpf/fits_ulong.c",
    "mpf/fits_ushort.c",
    "mpf/get_d.c",
    "mpf/get_d_2exp.c",
    "mpf/get_dfl_prec.c",
    "mpf/get_prc.c",
    "mpf/get_si.c",
    "mpf/get_str.c",
    "mpf/get_ui.c",
    "mpf/init.c",
    "mpf/init2.c",
    "mpf/inits.c",
    "mpf/inp_str.c",
    "mpf/int_p.c",
    "mpf/iset.c",
    "mpf/iset_d.c",
    "mpf/iset_si.c",
    "mpf/iset_str.c",
    "mpf/iset_ui.c",
    "mpf/mul.c",
    "mpf/mul_2exp.c",
    "mpf/mul_ui.c",
    "mpf/neg.c",
    "mpf/out_str.c",
    "mpf/pow_ui.c",
    "mpf/random2.c",
    "mpf/reldiff.c",
    "mpf/set.c",
    "mpf/set_d.c",
    "mpf/set_dfl_prec.c",
    "mpf/set_prc.c",
    "mpf/set_prc_raw.c",
    "mpf/set_q.c",
    "mpf/set_si.c",
    "mpf/set_str.c",
    "mpf/set_ui.c",
    "mpf/set_z.c",
    "mpf/size.c",
    "mpf/sqrt.c",
    "mpf/sqrt_ui.c",
    "mpf/sub.c",
    "mpf/sub_ui.c",
    "mpf/swap.c",
    "mpf/trunc.c",
    "mpf/ui_div.c",
    "mpf/ui_sub.c",
    "mpf/urandomb.c",

    "mpn/generic/add.c",
    "mpn/generic/add_1.c",
    "mpn/generic/add_err1_n.c",
    "mpn/generic/add_err2_n.c",
    "mpn/generic/add_err3_n.c",
    "mpn/generic/add_n_sub_n.c",
    "mpn/generic/bdiv_q.c",
    "mpn/generic/bdiv_qr.c",
    "mpn/generic/binvert.c",
    "mpn/generic/broot.c",
    "mpn/generic/brootinv.c",
    "mpn/generic/bsqrt.c",
    "mpn/generic/bsqrtinv.c",
    "mpn/generic/cmp.c",
    "mpn/generic/cnd_swap.c",
    "mpn/generic/comb_tables.c",
    "mpn/generic/compute_powtab.c",
    "mpn/generic/dcpi1_bdiv_q.c",
    "mpn/generic/dcpi1_bdiv_qr.c",
    "mpn/generic/dcpi1_div_q.c",
    "mpn/generic/dcpi1_div_qr.c",
    "mpn/generic/dcpi1_divappr_q.c",
    "mpn/generic/div_q.c",
    "mpn/generic/div_qr_1.c",
    "mpn/generic/div_qr_1n_pi1.c",
    "mpn/generic/div_qr_2.c",
    "mpn/generic/div_qr_2n_pi1.c",
    "mpn/generic/div_qr_2u_pi1.c",
    "mpn/generic/dive_1.c",
    "mpn/generic/diveby3.c",
    "mpn/generic/divexact.c",
    "mpn/generic/divis.c",
    "mpn/generic/divrem.c",
    "mpn/generic/divrem_1.c",
    "mpn/generic/divrem_2.c",
    "mpn/generic/dump.c",
    "mpn/generic/fib2_ui.c",
    "mpn/generic/fib2m.c",
    "mpn/generic/gcd.c",
    "mpn/generic/gcd_1.c",
    "mpn/generic/gcd_subdiv_step.c",
    "mpn/generic/gcdext.c",
    "mpn/generic/gcdext_1.c",
    "mpn/generic/gcdext_lehmer.c",
    "mpn/generic/get_d.c",
    "mpn/generic/get_str.c",
    "mpn/generic/hgcd.c",
    "mpn/generic/hgcd2.c",
    "mpn/generic/hgcd2_jacobi.c",
    "mpn/generic/hgcd_appr.c",
    "mpn/generic/hgcd_jacobi.c",
    "mpn/generic/hgcd_matrix.c",
    "mpn/generic/hgcd_reduce.c",
    "mpn/generic/hgcd_step.c",
    "mpn/generic/invert.c",
    "mpn/generic/invertappr.c",
    "mpn/generic/jacbase.c",
    "mpn/generic/jacobi.c",
    "mpn/generic/jacobi_2.c",
    "mpn/generic/matrix22_mul.c",
    "mpn/generic/matrix22_mul1_inverse_vector.c",
    "mpn/generic/mod_1.c",
    "mpn/generic/mod_1_1.c",
    "mpn/generic/mod_1_2.c",
    "mpn/generic/mod_1_3.c",
    "mpn/generic/mod_1_4.c",
    "mpn/generic/mode1o.c",
    "mpn/generic/mu_bdiv_q.c",
    "mpn/generic/mu_bdiv_qr.c",
    "mpn/generic/mu_div_q.c",
    "mpn/generic/mu_div_qr.c",
    "mpn/generic/mu_divappr_q.c",
    "mpn/generic/mul.c",
    "mpn/generic/mul_basecase.c",
    "mpn/generic/mul_fft.c",
    "mpn/generic/mul_n.c",
    "mpn/generic/mullo_basecase.c",
    "mpn/generic/mullo_n.c",
    "mpn/generic/mulmid.c",
    "mpn/generic/mulmid_basecase.c",
    "mpn/generic/mulmid_n.c",
    "mpn/generic/mulmod_bnm1.c",
    "mpn/generic/neg.c",
    "mpn/generic/nussbaumer_mul.c",
    "mpn/generic/perfpow.c",
    "mpn/generic/perfsqr.c",
    "mpn/generic/pow_1.c",
    "mpn/generic/powlo.c",
    "mpn/generic/powm.c",
    "mpn/generic/pre_divrem_1.c",
    "mpn/generic/pre_mod_1.c",
    "mpn/generic/random.c",
    "mpn/generic/random2.c",
    "mpn/generic/redc_1.c",
    "mpn/generic/redc_2.c",
    "mpn/generic/redc_n.c",
    "mpn/generic/remove.c",
    "mpn/generic/rootrem.c",
    "mpn/generic/sbpi1_bdiv_q.c",
    "mpn/generic/sbpi1_bdiv_qr.c",
    "mpn/generic/sbpi1_bdiv_r.c",
    "mpn/generic/sbpi1_div_q.c",
    "mpn/generic/sbpi1_div_qr.c",
    "mpn/generic/sbpi1_divappr_q.c",
    "mpn/generic/scan0.c",
    "mpn/generic/scan1.c",
    // "mpn/generic/sec_aors_1.c",
    // "mpn/generic/sec_div.c",
    "mpn/generic/sec_invert.c",
    "mpn/generic/sec_mul.c",
    // "mpn/generic/sec_pi1_div.c",
    "mpn/generic/sec_powm.c",
    "mpn/generic/sec_sqr.c",
    "mpn/generic/set_str.c",
    "mpn/generic/sizeinbase.c",
    "mpn/generic/sqr.c",
    "mpn/generic/sqr_basecase.c",
    "mpn/generic/sqrlo.c",
    "mpn/generic/sqrlo_basecase.c",
    "mpn/generic/sqrmod_bnm1.c",
    "mpn/generic/sqrtrem.c",
    "mpn/generic/strongfibo.c",
    "mpn/generic/sub.c",
    "mpn/generic/sub_1.c",
    "mpn/generic/sub_err1_n.c",
    "mpn/generic/sub_err2_n.c",
    "mpn/generic/sub_err3_n.c",
    "mpn/generic/tdiv_qr.c",
    "mpn/generic/toom22_mul.c",
    "mpn/generic/toom2_sqr.c",
    "mpn/generic/toom32_mul.c",
    "mpn/generic/toom33_mul.c",
    "mpn/generic/toom3_sqr.c",
    "mpn/generic/toom42_mul.c",
    "mpn/generic/toom42_mulmid.c",
    "mpn/generic/toom43_mul.c",
    "mpn/generic/toom44_mul.c",
    "mpn/generic/toom4_sqr.c",
    "mpn/generic/toom52_mul.c",
    "mpn/generic/toom53_mul.c",
    "mpn/generic/toom54_mul.c",
    "mpn/generic/toom62_mul.c",
    "mpn/generic/toom63_mul.c",
    "mpn/generic/toom6_sqr.c",
    "mpn/generic/toom6h_mul.c",
    "mpn/generic/toom8_sqr.c",
    "mpn/generic/toom8h_mul.c",
    "mpn/generic/toom_couple_handling.c",
    "mpn/generic/toom_eval_dgr3_pm1.c",
    "mpn/generic/toom_eval_dgr3_pm2.c",
    "mpn/generic/toom_eval_pm1.c",
    "mpn/generic/toom_eval_pm2.c",
    "mpn/generic/toom_eval_pm2exp.c",
    "mpn/generic/toom_eval_pm2rexp.c",
    "mpn/generic/toom_interpolate_12pts.c",
    "mpn/generic/toom_interpolate_16pts.c",
    "mpn/generic/toom_interpolate_5pts.c",
    "mpn/generic/toom_interpolate_6pts.c",
    "mpn/generic/toom_interpolate_7pts.c",
    "mpn/generic/toom_interpolate_8pts.c",
    "mpn/generic/trialdiv.c",
    "mpn/generic/zero.c",
    "mpn/generic/zero_p.c",

    "mpq/abs.c",
    "mpq/aors.c",
    "mpq/canonicalize.c",
    "mpq/clear.c",
    "mpq/clears.c",
    "mpq/cmp.c",
    "mpq/cmp_si.c",
    "mpq/cmp_ui.c",
    "mpq/div.c",
    "mpq/equal.c",
    "mpq/get_d.c",
    "mpq/get_den.c",
    "mpq/get_num.c",
    "mpq/get_str.c",
    "mpq/init.c",
    "mpq/inits.c",
    "mpq/inp_str.c",
    "mpq/inv.c",
    "mpq/md_2exp.c",
    "mpq/mul.c",
    "mpq/neg.c",
    "mpq/out_str.c",
    "mpq/set.c",
    "mpq/set_d.c",
    "mpq/set_den.c",
    "mpq/set_f.c",
    "mpq/set_num.c",
    "mpq/set_si.c",
    "mpq/set_str.c",
    "mpq/set_ui.c",
    "mpq/set_z.c",
    "mpq/swap.c",

    "mpz/2fac_ui.c",
    "mpz/abs.c",
    "mpz/add.c",
    "mpz/add_ui.c",
    "mpz/and.c",
    "mpz/aorsmul.c",
    "mpz/aorsmul_i.c",
    "mpz/array_init.c",
    "mpz/bin_ui.c",
    "mpz/bin_uiui.c",
    "mpz/cdiv_q.c",
    "mpz/cdiv_q_ui.c",
    "mpz/cdiv_qr.c",
    "mpz/cdiv_qr_ui.c",
    "mpz/cdiv_r.c",
    "mpz/cdiv_r_ui.c",
    "mpz/cdiv_ui.c",
    "mpz/cfdiv_q_2exp.c",
    "mpz/cfdiv_r_2exp.c",
    "mpz/clear.c",
    "mpz/clears.c",
    "mpz/clrbit.c",
    "mpz/cmp.c",
    "mpz/cmp_d.c",
    "mpz/cmp_si.c",
    "mpz/cmp_ui.c",
    "mpz/cmpabs.c",
    "mpz/cmpabs_d.c",
    "mpz/cmpabs_ui.c",
    "mpz/com.c",
    "mpz/combit.c",
    "mpz/cong.c",
    "mpz/cong_2exp.c",
    "mpz/cong_ui.c",
    "mpz/dive_ui.c",
    "mpz/divegcd.c",
    "mpz/divexact.c",
    "mpz/divis.c",
    "mpz/divis_2exp.c",
    "mpz/divis_ui.c",
    "mpz/dump.c",
    "mpz/export.c",
    "mpz/fac_ui.c",
    "mpz/fdiv_q.c",
    "mpz/fdiv_q_ui.c",
    "mpz/fdiv_qr.c",
    "mpz/fdiv_qr_ui.c",
    "mpz/fdiv_r.c",
    "mpz/fdiv_r_ui.c",
    "mpz/fdiv_ui.c",
    "mpz/fib2_ui.c",
    "mpz/fib_ui.c",
    "mpz/fits_sint.c",
    "mpz/fits_slong.c",
    "mpz/fits_sshort.c",
    "mpz/fits_uint.c",
    "mpz/fits_ulong.c",
    "mpz/fits_ushort.c",
    "mpz/gcd.c",
    "mpz/gcd_ui.c",
    "mpz/gcdext.c",
    "mpz/get_d.c",
    "mpz/get_d_2exp.c",
    "mpz/get_si.c",
    "mpz/get_str.c",
    "mpz/get_ui.c",
    "mpz/getlimbn.c",
    "mpz/hamdist.c",
    "mpz/import.c",
    "mpz/init.c",
    "mpz/init2.c",
    "mpz/inits.c",
    "mpz/inp_raw.c",
    "mpz/inp_str.c",
    "mpz/invert.c",
    "mpz/ior.c",
    "mpz/iset.c",
    "mpz/iset_d.c",
    "mpz/iset_si.c",
    "mpz/iset_str.c",
    "mpz/iset_ui.c",
    "mpz/jacobi.c",
    "mpz/kronsz.c",
    "mpz/kronuz.c",
    "mpz/kronzs.c",
    "mpz/kronzu.c",
    "mpz/lcm.c",
    "mpz/lcm_ui.c",
    "mpz/limbs_finish.c",
    "mpz/limbs_modify.c",
    "mpz/limbs_read.c",
    "mpz/limbs_write.c",
    "mpz/lucmod.c",
    "mpz/lucnum2_ui.c",
    "mpz/lucnum_ui.c",
    "mpz/mfac_uiui.c",
    "mpz/millerrabin.c",
    "mpz/mod.c",
    "mpz/mul.c",
    "mpz/mul_2exp.c",
    "mpz/mul_si.c",
    "mpz/mul_ui.c",
    "mpz/n_pow_ui.c",
    "mpz/neg.c",
    "mpz/nextprime.c",
    "mpz/oddfac_1.c",
    "mpz/out_raw.c",
    "mpz/out_str.c",
    "mpz/perfpow.c",
    "mpz/perfsqr.c",
    "mpz/popcount.c",
    "mpz/pow_ui.c",
    "mpz/powm.c",
    "mpz/powm_sec.c",
    "mpz/powm_ui.c",
    "mpz/pprime_p.c",
    "mpz/primorial_ui.c",
    "mpz/prodlimbs.c",
    "mpz/random.c",
    "mpz/random2.c",
    "mpz/realloc.c",
    "mpz/realloc2.c",
    "mpz/remove.c",
    "mpz/roinit_n.c",
    "mpz/root.c",
    "mpz/rootrem.c",
    "mpz/rrandomb.c",
    "mpz/scan0.c",
    "mpz/scan1.c",
    "mpz/set.c",
    "mpz/set_d.c",
    "mpz/set_f.c",
    "mpz/set_q.c",
    "mpz/set_si.c",
    "mpz/set_str.c",
    "mpz/set_ui.c",
    "mpz/setbit.c",
    "mpz/size.c",
    "mpz/sizeinbase.c",
    "mpz/sqrt.c",
    "mpz/sqrtrem.c",
    "mpz/stronglucas.c",
    "mpz/sub.c",
    "mpz/sub_ui.c",
    "mpz/swap.c",
    "mpz/tdiv_q.c",
    "mpz/tdiv_q_2exp.c",
    "mpz/tdiv_q_ui.c",
    "mpz/tdiv_qr.c",
    "mpz/tdiv_qr_ui.c",
    "mpz/tdiv_r.c",
    "mpz/tdiv_r_2exp.c",
    "mpz/tdiv_r_ui.c",
    "mpz/tdiv_ui.c",
    "mpz/tstbit.c",
    "mpz/ui_pow_ui.c",
    "mpz/ui_sub.c",
    "mpz/urandomb.c",
    "mpz/urandomm.c",
    "mpz/xor.c",

    "printf/asprintf.c",
    "printf/asprntffuns.c",
    "printf/doprnt.c",
    "printf/doprntf.c",
    "printf/doprnti.c",
    "printf/fprintf.c",
    "printf/obprintf.c",
    "printf/obprntffuns.c",
    "printf/obvprintf.c",
    "printf/printf.c",
    "printf/printffuns.c",
    "printf/repl-vsnprintf.c",
    "printf/snprintf.c",
    "printf/snprntffuns.c",
    "printf/sprintf.c",
    "printf/sprintffuns.c",
    "printf/vasprintf.c",
    "printf/vfprintf.c",
    "printf/vprintf.c",
    "printf/vsnprintf.c",
    "printf/vsprintf.c",

    "rand/rand.c",
    "rand/randbui.c",
    "rand/randclr.c",
    "rand/randdef.c",
    "rand/randiset.c",
    "rand/randlc2s.c",
    "rand/randlc2x.c",
    "rand/randmt.c",
    "rand/randmts.c",
    "rand/randmui.c",
    "rand/rands.c",
    "rand/randsd.c",
    "rand/randsdui.c",

    "scanf/doscan.c",
    "scanf/fscanf.c",
    "scanf/fscanffuns.c",
    "scanf/scanf.c",
    "scanf/sscanf.c",
    "scanf/sscanffuns.c",
    "scanf/vfscanf.c",
    "scanf/vscanf.c",
    "scanf/vsscanf.c",
};
