#!/usr/bin/env node
import { glob } from "glob";
import matter from "gray-matter";
import yaml from "js-yaml";
import postgres from "postgres";

const sql = postgres(
    process.env.POSTGRES_ADMIN_URL || "postgres://postgres:password@localhost:5432/postgres"
);

for await (const filename of (await glob("content/**/*.md"))) {
    const data = matter.read(filename, {
        engines: {
            yaml: (s) => yaml.load(s, { schema: yaml.JSON_SCHEMA })
        }
    });
    console.log(`Import ${filename}`);
    await sql`
        INSERT INTO public.notes
        (
            filename,
            content
        )
        VALUES(
            ${filename},
            ${data.content}
        )
        ON CONFLICT (filename) DO UPDATE
            SET content=${data.content}
        RETURNING id
    `;
};

sql.end();
