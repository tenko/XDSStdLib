(** Module with common library constants *)
MODULE Const ;

IMPORT SYSTEM, COMPILER;

CONST
    VERSION* = "0.1";
    BUILD* = "1";
    HOST* = COMPILER.EQUATION("ENV_HOST");
    TARGET* = COMPILER.EQUATION("ENV_TARGET");
    CPU* = COMPILER.EQUATION("CPU");
    WORDSIZE* = 4;
    -- Comparison --
    EQUAL*      = 0;
    GREATER*    = 1;
    LESS*       = -1;
    NONCOMPARED*= 2;
    -- Log --
    DEBUG*  = 4;
    INFO*   = 3;
    WARN*   = 2;
    ERROR*  = 1;
    FATAL*  = 0;
    -- Formatting --
    FmtLeft* = {0};     FmtRight* = {1};    FmtCenter* = {2};
    FmtSign* = {3};     FmtZero* = {4};     FmtSpc* = {5};
    FmtAlt* = {6};      FmtUpper* = {7};
    -- LongReal / Real --
    FPZero* = 0;
    FPNormal* = 1;
    FPSubnormal* = 2;
    FPInfinite* = 3;
    FPNaN* = 4;
    -- Stream Seek --
    SeekSet* = 0;
    SeekCur* = 1;
    SeekEnd* = 2;
    -- Stream Error --
    StreamOK* = 0;
    StreamNotImplementedError* = 1;
    StreamNotOpenError* = 2;
    StreamReadError* = 3;
    StreamWriteError* = 4;
END Const.