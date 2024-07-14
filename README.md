# Import Obsidian vault to pg_search

In this project, I'm testing [pg_search](https://github.com/paradedb/paradedb/tree/dev/pg_search) on the contents of an [Obsidian](https://obsidian.md/) vault.

```sh
$ mise install
$ pnpm install
$ docker compose up -d --wait
```

```sh
$ ./scripts/enter-in-pg.sh -f init.sql
$ ./import.js
```

The source code of the `search.js` script returns the result of a search on "CodeMirror":

```sh
$ ./search.js
...
```
