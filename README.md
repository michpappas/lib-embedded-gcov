# lib-embedded-gcov

Unikraft port of [embedded-gcov](https://github.com/nasa-jpl/embedded-gcov).

## Initialization and Termination

Initialization of gcov is done transparently to the application. `lib-embedded-gcov` adds the required GCC options for coverage, and at runtime `__gcov_init()` is automatically call when Unikraft boots via constructors.

To dump the coverage data you need to update the application to manually call `__gcov_exit()`.

## Collecting Coverage Results

embedded-gcov provides three types of output:
- Binary file
- Memory
- Serial console

At this moment `lib-gcov-embedded` supports only serial console output.

### Serial Console Output

To obtain coverage results via the console you need to dump the console output into a file. With QEMU this is possible by configuring the serial device to log all output into a file:
```
-chardev stdio,id=char0,logfile=serial.log,signal=off -serial chardev:char0
```

The console output then needs to be processed into an lcov report. `lib-embedded-gcov` provides the `gcov_process.sh` script for that, which is essentially a wrapper around the tools provided by `embedded-gcov`.

Before executing the script make sure you have the required dependencies installed, that is:
- dox2unix
- lcov

With dependencies installed, execute the script as:
```
lib-embedded-gcov/scripts/gcov_process.sh <build_directory> <console_log>
```

The script will generate an lcov report and provide a link as shown below.
```
...
Writing directory view page.
Overall coverage rate:
  lines......: 29.8% (2345 of 7858 lines)
  functions..: 36.3% (228 of 628 functions)

lcov report in file:///home/mpp/devel/unikraft_oss/uk_embedded-gcov/app-helloworld/build/libembeddedgcov/origin/results/html/index.html
```

