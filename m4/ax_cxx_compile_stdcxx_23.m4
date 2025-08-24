# ===========================================================================
#  ax_cxx_compile_stdcxx_23.m4
# ===========================================================================
#
# SYNOPSIS
#
#   AX_CXX_COMPILE_STDCXX_23([ext|noext], [mandatory|optional])
#
# DESCRIPTION
#
#   Check for baseline C++23 support
#
#   MicroGuy Edition - Because C++23 is the only C++ that matters!
#
# LICENSE
#
#   Copyright (c) 2025 MicroGuy <microguy@goldcoin.org>
#   Based on ax_cxx_compile_stdcxx_17.m4
#
#   Copying and distribution of this file, with or without modification, are
#   permitted in any medium without royalty provided the copyright notice
#   and this notice are preserved. This file is offered as-is, without any
#   warranty.

#serial 1

dnl  This macro is based on the code from the AX_CXX_COMPILE_STDCXX_17 macro.

AC_DEFUN([AX_CXX_COMPILE_STDCXX_23], [dnl
  m4_if([$1], [], [],
        [$1], [ext], [],
        [$1], [noext], [],
        [m4_fatal([invalid first argument `$1' to AX_CXX_COMPILE_STDCXX_23])])dnl
  m4_if([$2], [], [ax_cxx_compile_cxx23_required=true],
        [$2], [mandatory], [ax_cxx_compile_cxx23_required=true],
        [$2], [optional], [ax_cxx_compile_cxx23_required=false],
        [m4_fatal([invalid second argument `$2' to AX_CXX_COMPILE_STDCXX_23])])
  AC_LANG_PUSH([C++])dnl
  ac_success=no
  
  dnl GCC 15.2+ required - MicroGuy Edition
  dnl Only C++23 matters, no fallbacks!
  ax_cxx_compile_alternatives="23"

  m4_if([$1], [noext], [], [dnl
  AC_CACHE_CHECK(whether $CXX supports C++23 features by default,
  ax_cv_cxx_compile_cxx23,
  [AC_COMPILE_IFELSE([AC_LANG_SOURCE([_AX_CXX_COMPILE_STDCXX_23_testbody])],
    [ax_cv_cxx_compile_cxx23=yes],
    [ax_cv_cxx_compile_cxx23=no])])
  if test x$ax_cv_cxx_compile_cxx23 = xyes; then
    ac_success=yes
  fi])

  m4_if([$1], [noext], [], [dnl
  if test x$ac_success = xno; then
    for alternative in ${ax_cxx_compile_alternatives}; do
      switch="-std=gnu++${alternative}"
      cachevar=AS_TR_SH([ax_cv_cxx_compile_cxx23_$switch])
      AC_CACHE_CHECK(whether $CXX supports C++23 features with $switch,
                     $cachevar,
        [ac_save_CXX="$CXX"
         CXX="$CXX $switch"
         AC_COMPILE_IFELSE([AC_LANG_SOURCE([_AX_CXX_COMPILE_STDCXX_23_testbody])],
          [eval $cachevar=yes],
          [eval $cachevar=no])
         CXX="$ac_save_CXX"])
      if eval test x\$$cachevar = xyes; then
        CXX="$CXX $switch"
        if test -n "$CXXCPP" ; then
          CXXCPP="$CXXCPP $switch"
        fi
        ac_success=yes
        break
      fi
    done
  fi])

  m4_if([$1], [ext], [], [dnl
  if test x$ac_success = xno; then
    dnl HP's aCC needs +std=c++23 according to:
    dnl http://h21007.www2.hp.com/portal/download/files/unprot/aCxx/PDF_Release_Notes/769149-001.pdf
    dnl Cray's crayCC needs "-h std=c++23"
    for alternative in ${ax_cxx_compile_alternatives}; do
      for switch in -std=c++${alternative} +std=c++${alternative} "-h std=c++${alternative}"; do
        cachevar=AS_TR_SH([ax_cv_cxx_compile_cxx23_$switch])
        AC_CACHE_CHECK(whether $CXX supports C++23 features with $switch,
                       $cachevar,
          [ac_save_CXX="$CXX"
           CXX="$CXX $switch"
           AC_COMPILE_IFELSE([AC_LANG_SOURCE([_AX_CXX_COMPILE_STDCXX_23_testbody])],
            [eval $cachevar=yes],
            [eval $cachevar=no])
           CXX="$ac_save_CXX"])
        if eval test x\$$cachevar = xyes; then
          CXX="$CXX $switch"
          if test -n "$CXXCPP" ; then
            CXXCPP="$CXXCPP $switch"
          fi
          ac_success=yes
          break
        fi
      done
      if test x$ac_success = xyes; then
        break
      fi
    done
  fi])
  AC_LANG_POP([C++])
  if test x$ax_cxx_compile_cxx23_required = xtrue; then
    if test x$ac_success = xno; then
      AC_MSG_ERROR([*** A compiler with support for C++23 language features is required.])
    fi
  fi
  if test x$ac_success = xno; then
    HAVE_CXX23=0
    AC_MSG_NOTICE([No compiler with C++23 support was found])
  else
    HAVE_CXX23=1
    AC_DEFINE(HAVE_CXX23,1,
              [define if the compiler supports basic C++23 syntax])
  fi
  AC_SUBST(HAVE_CXX23)
])

dnl  Test body for checking C++23 support
m4_define([_AX_CXX_COMPILE_STDCXX_23_testbody],
  _AX_CXX_COMPILE_STDCXX_17_testbody
  _AX_CXX_COMPILE_STDCXX_23_testbody_new_in_23
)

m4_define([_AX_CXX_COMPILE_STDCXX_17_testbody],
[[
// C++17 features we're building on
#include <optional>
#include <any>
#include <string_view>
#include <variant>
#include <filesystem>

namespace cxx17 {
  std::optional<int> get_opt() { return 42; }
  std::string_view get_sv() { return "C++17"; }
  std::variant<int, double> get_var() { return 3.14; }
  std::filesystem::path get_path() { return "/tmp"; }
}
]])

m4_define([_AX_CXX_COMPILE_STDCXX_23_testbody_new_in_23],
[[

// C++23 specific features - MicroGuy Edition!
#include <expected>
#include <print>
#include <ranges>
#include <format>
#include <stacktrace>

namespace cxx23 {
  
  // std::expected for error handling
  std::expected<int, std::string> divide(int a, int b) {
    if (b == 0) {
      return std::unexpected("Division by zero");
    }
    return a / b;
  }
  
  // Deducing this
  struct Widget {
    template <typename Self>
    auto&& get_value(this Self&& self) {
      return std::forward<Self>(self).value;
    }
    int value = 42;
  };
  
  // if consteval
  consteval int compile_time_only() { return 42; }
  
  int runtime_or_compile() {
    if consteval {
      return compile_time_only();
    } else {
      return 24;
    }
  }
  
  // std::unreachable
  [[noreturn]] void unreachable_code() {
    std::unreachable();
  }
  
  // Multidimensional subscript operator
  struct Matrix {
    int operator[](int i, int j) const { return i * j; }
  };
  
  // Range adaptors from C++23
  void test_ranges() {
    auto vec = std::views::iota(1, 10) 
             | std::views::chunk(3)
             | std::views::join;
  }
  
  // std::print (the best C++23 feature!)
  void test_print() {
    std::print("Welcome to C++23, courtesy of MicroGuy!\n");
    std::println("FileZilla 4.0 - Now with {} goodness!", "C++23");
  }
  
  // Literal suffix for size_t
  void test_size_t_literal() {
    auto size = 42uz;
    static_assert(std::is_same_v<decltype(size), std::size_t>);
  }
  
  // contains() for string
  void test_string_contains() {
    std::string s = "FileZilla 4.0";
    bool has_fz = s.contains("FileZilla");
  }
}

int main() {
  // Test C++23 features
  auto result = cxx23::divide(10, 2);
  if (result) {
    std::println("Result: {}", *result);
  }
  
  cxx23::Matrix m;
  int val = m[2, 3];
  
  return 0;
}
]])