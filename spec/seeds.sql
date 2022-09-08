TRUNCATE TABLE user_accounts, posts RESTART IDENTITY;

INSERT INTO user_accounts (email, username) VALUES 
  ('yq2550@gmail.com', 'oahciy'),
  ('givemeanaddress@outlook.com', 'mystery');

INSERT INTO posts (title, content, views, user_account_id) VALUES 
('title_1', 'content_1', 10, 1),
('title_2', 'content_2', 2, 2);