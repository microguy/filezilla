# CHECK_GCC_VERSION
# -----------------
# MicroGuy Edition - Enforce GCC 15.2 or higher
# Because only the latest and greatest will do!

AC_DEFUN([CHECK_GCC_VERSION], [
  AC_MSG_CHECKING([for GCC version >= 15.2])
  
  if test "$GXX" = "yes"; then
    # Extract GCC version
    gcc_version=`$CXX -dumpversion`
    gcc_major=`echo $gcc_version | cut -d. -f1`
    gcc_minor=`echo $gcc_version | cut -d. -f2`
    
    # Check for GCC 15.2+
    if test "$gcc_major" -lt 15; then
      AC_MSG_ERROR([
*** GCC 15.2 or higher is required for FileZilla 4.0 - MicroGuy Edition
*** You have GCC $gcc_version
*** C++23 is the only way forward!
*** Download GCC 15.2 from https://gcc.gnu.org/gcc-15/
      ])
    elif test "$gcc_major" -eq 15 -a "$gcc_minor" -lt 2; then
      AC_MSG_ERROR([
*** GCC 15.2 or higher is required for FileZilla 4.0 - MicroGuy Edition
*** You have GCC $gcc_version
*** Please upgrade to GCC 15.2 (released August 8, 2025)
      ])
    else
      AC_MSG_RESULT([yes (GCC $gcc_version)])
      AC_DEFINE_UNQUOTED([COMPILER_VERSION], ["GCC $gcc_version"], [Compiler version])
    fi
  else
    AC_MSG_ERROR([
*** GCC 15.2+ is required for FileZilla 4.0 - MicroGuy Edition
*** Only GCC is supported for this build
*** No other compiler matters in the C++23 world!
    ])
  fi
])