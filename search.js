#!/usr/bin/env node
import postgres from "postgres";

const sql = postgres(
    process.env.POSTGRES_ADMIN_URL || "postgres://postgres:password@localhost:5432/postgres"
);

for await (const row of (
    await sql`
        SELECT content FROM notes_search_idx.search('content:CodeMirror')
    `
)) {
    console.log(row.content);
}

sql.end();
