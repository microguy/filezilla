# FileZilla 4.0 - MicroGuy Edition

## Overview
This is a customized version of FileZilla 3.69.3, upgraded to version 4.0 with specific modifications to improve SFTP reconnection performance.

## Key Modifications

### 1. SFTP Reconnection Timeout Fix (3 seconds)
**Problem:** Original FileZilla had a 1-2 minute delay when reconnecting idle SFTP sessions.

**Solution:** Modified TCP connection timeout to 3 seconds in `/src/putty/windows/winnet.c`

**Location:** `/src/putty/windows/winnet.c` (lines ~1040-1140)

**Technical Details:**
- Added non-blocking socket mode with `ioctlsocket(s, FIONBIO, &nonblock)`
- Implemented custom `select()` with 3-second timeout
- Handles connection success/failure/timeout scenarios properly
- Returns appropriate error messages on timeout

### 2. Version Update
**Changed:** Version bumped from 3.69.3 to 4.0.0

**Files Modified:**
- `/configure.ac` - Updated AC_INIT version
- `/NEWS` - Added 4.0.0 release notes

### 3. Copyright Addition
**Added:** "Copyright (C) 2025 MicroGuy" to About dialog

**Location:** `/src/interface/aboutdialog.cpp` (line ~41)

## Build Configuration

### Cross-Compilation for Windows
Built using MinGW-w64 on Ubuntu Linux for Windows x64 target.

### Dependencies Built
- SQLite 3 (with FTS5 and RTree support)
- GMP 6.2+
- Nettle 3.3+
- GnuTLS 3.7.0+
- libfilezilla 0.51.1+
- wxWidgets 3.2.5
- Boost.Regex (for GCC bug workaround)

### Build Scripts
- `build-windows-filezilla.sh` - Main build script with dependency compilation
- `build-wx-and-filezilla.sh` - Dynamic linking build script for faster compilation

### Build Flags
```bash
--host=x86_64-w64-mingw32
--prefix=$HOME/git/win-prefix
--with-pugixml=builtin
--disable-manualupdatecheck
--disable-autoupdatecheck
```

## Performance Improvements

### Before
- SFTP reconnection after idle: 60-120 seconds
- Users experienced long delays when resuming work

### After  
- SFTP reconnection after idle: 3 seconds maximum
- Immediate timeout and retry if server doesn't respond
- Better user experience with faster failure detection

## Testing Recommendations

1. Test SFTP connections to various servers
2. Leave connection idle for 10+ minutes
3. Attempt file operations (download, rename, directory listing)
4. Verify 3-second timeout on reconnection attempts
5. Test with both responsive and unresponsive servers

## Building from Source

### Prerequisites
```bash
sudo apt-get install mingw-w64 autoconf automake libtool pkg-config
```

### Quick Build (Dynamic Linking)
```bash
./build-wx-and-filezilla.sh
```

### Full Build (All Dependencies)
```bash
./build-windows-filezilla.sh
```

### Output
- Executable: `filezilla-build-win64/src/interface/.libs/filezilla.exe`
- Can be used as drop-in replacement for existing FileZilla installation

## Known Issues
- libfilezilla doesn't support static builds (must use DLLs)
- Some compiler warnings about DLL imports (can be ignored)
- Build process takes 20-35 minutes for full compilation

## Author
Modified by MicroGuy (2025)
Based on FileZilla by Tim Kosse

## License
FileZilla is distributed under the terms of the GNU General Public License version 2 or later.