USE `db-script`;
ALTER TABLE question ADD COLUMN is_ai_generated BIT(1) DEFAULT b'0';

ALTER TABLE question ADD COLUMN difficulty VARCHAR(20) DEFAULT 'medium';
ALTER TABLE question ADD COLUMN category VARCHAR(50) DEFAULT 'conceptual';

UPDATE question SET difficulty = 'medium', category = 'conceptual' WHERE difficulty IS NULL;