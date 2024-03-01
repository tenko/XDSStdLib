#####
Intro
#####

This library is developed for the *XDS Compiler* and optimized
for the *Oberon-2* language implementation with *XDS* extensions:

 * Default arguments are used extensive to simplify the API.

 * Variable arguments are used for printf style calling API.
   (This is a *Modula-2* construct and is not type safe.)

 * *Modula-2* constructs are sometimes used to implement functionallity.
   (e.g. support for unsigned integers)

The intended use case is small personal utilities and
applications on the Windows and Linux platform.
For now only the Windows platform is tested, but there
should be no big obstacles to get Linux up and running.

The API is a not intended to be compatibe with legacy code
and use comparable Python standard library API or POSIX
where it fits.

Note that currently the *XDSCompiler* is limited to
32bit platforms. There is support for 64bit data types,
but these have some bugs which this libarary tries to
work around.

There are some examples in the documentation (:ref:`UI`, :ref:`DBSqlite3`).
Otherwise the unit tests can be inspected for basic usage.

.. toctree::
    :maxdepth: 1
    :caption: Common:
    :hidden:

    src/Const.ob2
    src/Object.ob2
    src/Type.ob2

.. toctree::
    :maxdepth: 1
    :caption: Basic Data Types:
    :hidden:

    src/ArrayOfByte.ob2
    src/ArrayOfChar.ob2
    src/Byte.ob2
    src/Char.ob2
    src/DateTime.ob2
    src/Integer.ob2
    src/LongInt.ob2
    src/LongLongInt.ob2
    src/LongReal.ob2
    src/LongWord.ob2
    src/Real.ob2
    src/ShortInt.ob2
    src/String.ob2
    src/Word.ob2
    src/Type.ob2

.. toctree::
    :maxdepth: 1
    :caption: Abstract Data Types:
    :hidden:

    src/ADT.ob2
    src/ADTDictionary.ob2
    src/ADTList.ob2
    src/ADTSet.ob2
    src/ADTStream.ob2
    src/ADTTree.ob2
    src/ADTVector.ob2

.. toctree::
    :maxdepth: 1
    :caption: Library:
    :hidden:

    src/DataConfig.ob2
    src/DBSQLite3.ob2
    src/Format.ob2
    src/Log.ob2
    src/OS.ob2
    src/OSDir.ob2
    src/OSFile.ob2
    src/OSPath.ob2
    src/OSStream.ob2
    src/O2Testing.ob2
    src/O2Timing.ob2
    src/StringRegex.ob2
    src/UI.ob2


##################
Indices and tables
##################

* :ref:`genindex`
* :ref:`search`
