# SQLiteLib

The Xcode project, configuration, and license of
[swiftlyfalling/SQLiteLib](https://github.com/swiftlyfalling/SQLiteLib) at
`4a8b550`, which builds `libsqlitecustom.a` for the `GRDBCustom` framework.

Unlike upstream, the `sqlitecustom` target compiles the `sqlite3.c` and
`sqlite3.h` kept in this directory instead of running `configure` and `make`
on a copy of the SQLite source tree during each build. The `amalgamation`
target now only copies `SQLiteLib-USER.xcconfig.example` when no USER
configuration exists.

`SQLITE_VERSION` in `sqlite3.h` names the SQLite release. To change it, run
`scripts/update-sqlite.sh`; its header lists the arguments. The script
downloads the canonical sources, checks them against the release's check-in,
and generates a parser that honors `SQLITE_ENABLE_UPDATE_DELETE_LIMIT`.
