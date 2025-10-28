-- Example SQL schema for opinions app

-- Topics table
CREATE TABLE IF NOT EXISTS topics (
  id SERIAL PRIMARY KEY,
  title TEXT NOT NULL,
  description TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Users table
CREATE TABLE IF NOT EXISTS users (
  id SERIAL PRIMARY KEY,
  name TEXT NOT NULL,
  email TEXT NOT NULL UNIQUE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Votes table
CREATE TABLE IF NOT EXISTS votes (
  id SERIAL PRIMARY KEY,
  user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  topic_id INTEGER NOT NULL REFERENCES topics(id) ON DELETE CASCADE,
  vote SMALLINT NOT NULL CHECK (vote IN (-1, 1)), -- -1 = downvote, 1 = upvote
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  UNIQUE (user_id, topic_id)
);

-- Example seed data
INSERT INTO topics (title, description) VALUES
  ('Cats vs Dogs', 'Which pet is better?'),
  ('Remote work', 'Is remote work better than office work?')
ON CONFLICT DO NOTHING;

INSERT INTO users (name, email) VALUES
  ('Alice', 'alice@example.com'),
  ('Bob', 'bob@example.com')
ON CONFLICT DO NOTHING;

-- Example votes
INSERT INTO votes (user_id, topic_id, vote) VALUES
  (1, 1, 1),
  (2, 1, -1),
  (1, 2, 1)
ON CONFLICT DO NOTHING;
