.. index::
    single: DataConfig

.. _DataConfig:

**********
DataConfig
**********


`INI` file format config parser with similar functions to Python
version except for multiline values.


Types
=====

.. code-block:: modula2

    Parser* = POINTER TO ParserDesc;

.. code-block:: modula2

    ParserDesc* = RECORD
            sections* : Set.SetStr;
            entries* : Dictionary.DictionaryStrStr;
        END;

Procedures
==========

.. _DataConfig.InitParser:

InitParser
----------

.. code-block:: modula2

    PROCEDURE InitParser*(parser : Parser);

.. _DataConfig.Parser.Clear:

Parser.Clear
------------

 Clear data 

.. code-block:: modula2

    PROCEDURE (this : Parser) Clear*();

.. _DataConfig.Parser.Get:

Parser.Get
----------


Get config value.
Return `TRUE` if success.


.. code-block:: modula2

    PROCEDURE (this : Parser) Get*(VAR value : String.STRING; section- : ARRAY OF CHAR; key- : ARRAY OF CHAR) : BOOLEAN;

.. _DataConfig.Parser.Set:

Parser.Set
----------


Set config value.
Return `TRUE` if success.


.. code-block:: modula2

    PROCEDURE (this : Parser) Set*(section- : ARRAY OF CHAR; key- : ARRAY OF CHAR; value- : ARRAY OF CHAR) : BOOLEAN;

.. _DataConfig.Parser.Delete:

Parser.Delete
-------------


Delete config value.
Return `TRUE` if success.


.. code-block:: modula2

    PROCEDURE (this : Parser) Delete*(section- : ARRAY OF CHAR; key- : ARRAY OF CHAR) : BOOLEAN;

.. _DataConfig.Parser.DeleteSection:

Parser.DeleteSection
--------------------


Delete config section and coresponding entries.
Return `TRUE` if success.


.. code-block:: modula2

    PROCEDURE (this : Parser) DeleteSection*(section- : ARRAY OF CHAR) : BOOLEAN;

.. _DataConfig.Parser.HasSection:

Parser.HasSection
-----------------

 Return `TRUE` if section exists 

.. code-block:: modula2

    PROCEDURE (this : Parser) HasSection*(section- : ARRAY OF CHAR): BOOLEAN;

.. _DataConfig.Parser.Sections:

Parser.Sections
---------------

 Extract Vector of sections 

.. code-block:: modula2

    PROCEDURE (this : Parser) Sections*(): Vector.VectorOfString;

.. _DataConfig.Parser.Write:

Parser.Write
------------

 Write data to Stream 

.. code-block:: modula2

    PROCEDURE (this : Parser) Write*(fh : Object.Stream): BOOLEAN;

.. _DataConfig.Parser.Read:

Parser.Read
-----------


Read from Stream.
This operation will try to append the new data.
Clear the data before operation if this is not intended.


.. code-block:: modula2

    PROCEDURE (this : Parser) Read*(fh : Object.Stream): LONGINT;

