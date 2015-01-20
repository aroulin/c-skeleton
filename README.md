C-skeleton: one Makefile to rule them all
=========================================

Goal
----

Provide a C Makefile project skeleton to be used for any medium-sized project with build
dependencies, unit testing, documentation generation and much more !

Project organisation
--------------------
Source files (.[hcs]) found in the root folder and in any subfolders (except some special folders listed below) will be compiled into one main executable (or library).

Special folders:
+ build
    * out-of-tree build files
+ include
    * .h alternative location (in the include path)
+ doc
    * doxygen generated documentation
+ tests
    * tests files (framework to be chosen)
+ coverage
    * coverage report documents

Final target
------------
+ generate either executable, static or dynamic library (-fPIC flag)
+ only one main function in src/ directory (use #ifdef to have multiple)

Dependencies
------------
+ Must be able to add a new file in src/, include/ or tests/ without changing the Makefile
+ handle correctly header dependencies (using gcc flags)

Unit Testing
------------
+ custom testing framework or one that is available (check, unity, etc.)
+ coverage with gcov and lcov (html report)
+ valgrind check
+ mocking framework (cmock, cmocka)

Cross-compiling
---------------
+ A cross-compiler can be used with user-defined flags.
+ A custom linker script can be used.
+ Unit testing may still have to be done using the native compiler.

User-defined information
------------------------
+ names of folders
+ compiler and linker flags
+ external libraries to link (static + dynamic)
+ define if we must build an executable or a static/dynamic library
+ run target definition
+ Easily add new build commands, e.g build hex file from elf file

Bonus points
------------
+ Detect bad functions usage, e.g. gets. (See [1])

References
----------
+ [1] http://c.learncodethehardway.org
+ [2] http://stackoverflow.com/questions/14844268/makefile-template-for-large-c-project
