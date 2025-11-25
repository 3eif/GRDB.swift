/*
** sqlite3ext.h - SQLite Extension Header
** This header is needed for loading SQLite extensions like sqlite-vec.
*/
#ifndef SQLITE3EXT_H
#define SQLITE3EXT_H

/* Get sqlite3 definitions */
#include <GRDB/sqlite3.h>

#ifdef __cplusplus
extern "C" {
#endif

/* Auto-extension registration - these are defined in sqlite3.c */
SQLITE_API int sqlite3_auto_extension(void(*xEntryPoint)(void));
SQLITE_API int sqlite3_cancel_auto_extension(void(*xEntryPoint)(void));
SQLITE_API void sqlite3_reset_auto_extension(void);

/* Extension initialization macros */
#define SQLITE_EXTENSION_INIT1 const sqlite3_api_routines *sqlite3_api = 0;
#define SQLITE_EXTENSION_INIT2(v) sqlite3_api = v;
#define SQLITE_EXTENSION_INIT3 extern const sqlite3_api_routines *sqlite3_api;

#ifdef __cplusplus
}
#endif

#endif /* SQLITE3EXT_H */
