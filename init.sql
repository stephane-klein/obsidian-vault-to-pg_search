\o /dev/null
SET client_min_messages TO error;

DROP TABLE IF EXISTS public.notes;

-- public.notes table

CREATE TABLE public.notes (
    id          SERIAL PRIMARY KEY,
    filename    VARCHAR(255) UNIQUE NOT NULL,
    content     TEXT,
    created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE INDEX notes_id_index       ON public.notes (id);
CREATE INDEX notes_filename_index ON public.notes (filename);

CREATE OR REPLACE FUNCTION public.update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
   NEW.updated_at = NOW();
   RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS update_notes_updated_at ON public.notes;

CREATE TRIGGER update_notes_updated_at
BEFORE UPDATE ON public.notes
FOR EACH ROW
EXECUTE PROCEDURE public.update_updated_at_column();

CREATE EXTENSION IF NOT EXISTS pg_search CASCADE;

CALL paradedb.create_bm25(
        index_name => 'notes_search_idx',
        schema_name => 'public',
        table_name => 'notes',
        key_field => 'id',
        text_fields => '{content: {}}'
);

