#include <stdio.h>

struct ShellState;
ShellState* shell_state_init(const char* db_fn, FILE* out);

void shell_state_free(ShellState* state);

typedef struct ShellState ShellState;
struct ShellState {
    sqlite3 *db;
    u8 autoExplain;
    u8 autoEQP;
    u8 autoEQPtest;
    u8 autoEQPtrace;
    u8 scanstatsOn;
    u8 openMode;
    u8 doXdgOpen;
    u8 nEqpLevel;
    u8 eTraceType;
    u8 bSafeMode;
    u8 bSafeModePersist;
    ColModeOpts cmOpts;
    unsigned statsOn;
    unsigned mEqpLines;
    int inputNesting;
    int outCount;
    int cnt;
    int lineno;
    int openFlags;
    FILE *in;
    FILE *out;
    FILE *traceOut;
    int nErr;
    int mode;
    int modePrior;
    int cMode;
    int normalMode;
    int writableSchema;
    int showHeader;
    int nCheck;
    unsigned nProgress;
    unsigned mxProgress;
    unsigned flgProgress;
    unsigned shellFlgs;
    unsigned priorShFlgs;
    sqlite3_int64 szMax;
    char *zDestTable;
    char *zTempFile;
    char zTestcase[30];
    char colSeparator[20];
    char rowSeparator[20];
    char colSepPrior[20];
    char rowSepPrior[20];
    int *colWidth;
    int *actualWidth;
    int nWidth;
    char nullValue[20];
    char outfile[FILENAME_MAX];
    sqlite3_stmt *pStmt;
    FILE *pLog;
    struct AuxDb {
        sqlite3 *db;
        const char *zDbFilename;
        char *zFreeOnClose;
#if defined(SQLITE_ENABLE_SESSION)
        int nSession;
        OpenSession aSession[4];
#endif
    } aAuxDb[5],
      *pAuxDb;
    int *aiIndent;
    int nIndent;
    int iIndent;
    char *zNonce;
    EQPGraph sGraph;
    ExpertInfo expert;
};

int do_meta_command_r(char *zLine, struct ShellState *p);
