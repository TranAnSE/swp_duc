USE `db-script`;
ALTER TABLE question ADD COLUMN is_ai_generated BIT(1) DEFAULT b'0';