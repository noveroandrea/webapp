-- Example SQL schema for opinions app

-- Topics table
CREATE TABLE IF NOT EXISTS topics (
  id SERIAL PRIMARY KEY,
  title TEXT NOT NULL,
  description TEXT,
  total_votes INTEGER NOT NULL DEFAULT 0,
  yes_votes INTEGER NOT NULL DEFAULT 0,
  no_votes INTEGER NOT NULL DEFAULT 0,
  comment TEXT DEFAULT '',
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Users table
CREATE TABLE IF NOT EXISTS users (
  id SERIAL PRIMARY KEY,
  name TEXT NOT NULL,
  email TEXT NOT NULL UNIQUE,
  password TEXT NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Votes table
CREATE TABLE IF NOT EXISTS votes (
  user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  topic_id INTEGER NOT NULL REFERENCES topics(id) ON DELETE CASCADE,
  vote SMALLINT NOT NULL CHECK (vote IN (-1, 1, 0)), -- -1 = downvote, 1 = upvote
  comment TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  PRIMARY KEY (user_id, topic_id) 
);

-- Example seed data
INSERT INTO topics (title, description) VALUES
  ('Cats vs Dogs', 'Which pet is better?'),
  ('Remote work', 'Is remote work better than office work?'),
  ('Climate Change', 'Should we care?'),
  ('Messina Bridge', 'Do you support its construction?'),
  ('AI Ethics', 'Should AI be regulated?'),
  ('Minimum Wage', 'Should there be a minimum wage?'),
  ('Tax evasion', 'Should we combat tax evasion?'),
  ('Universal Basic Income', 'Is UBI a good idea?'),
  ('Space Exploration', 'Should we invest more in space?'),
  ('Data Privacy', 'Is data privacy a fundamental right?'),
  ('Electric Vehicles', 'Are electric vehicles the future?'),
  ('Renewable Energy', 'Should we switch to renewable energy?'),
  ('Social Media', 'Is social media harmful to society?'),
  ('Online Education', 'Is online education effective?'),
  ('Work-Life Balance', 'Is work-life balance achievable?')
ON CONFLICT DO NOTHING;

INSERT INTO users (name, email, password) VALUES
  ('Alice', 'alice@example.com', 'password123'),
  ('Bob', 'bob@example.com', 'password456')
ON CONFLICT DO NOTHING;

-- Example votes
INSERT INTO votes (user_id, topic_id, vote, comment) VALUES
  (1, 1, 1, 'I love cats!'),
  (2, 1, -1, 'Dogs are better.'),
  (1, 2, 1, 'Remote work is great!'),
  (2, 2, 0, 'A balance is ideal.')
ON CONFLICT DO NOTHING;
