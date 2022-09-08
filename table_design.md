# Two Tables Design Recipe Template

_Copy this recipe template to design and create two related database tables from a specification._

## 1. Extract nouns from the user stories or specification

```
# EXAMPLE USER STORY:
# (analyse only the relevant part - here the final line).

As a social network user,
So I can have my information registered,
I'd like to have a user account with my email address.

As a social network user,
So I can have my information registered,
I'd like to have a user account with my username.

As a social network user,
So I can write on my timeline,
I'd like to create posts associated with my user account.

As a social network user,
So I can write on my timeline,
I'd like each of my posts to have a title and a content.

As a social network user,
So I can know who reads my posts,
I'd like each of my posts to have a number of views.
```

```
Nouns:

user_account, email_address, username, post, post_title, post_content, views
```

## 2. Infer the Table Name and Columns

Put the different nouns in this table. Replace the example with your own nouns.

| Record                | Properties          |
| --------------------- | ------------------  |
| user_account          | email, username
| post                  | title, content, views

1. Name of the first table (always plural): `user_accounts` 

    Column names: `email`, `username`

2. Name of the second table (always plural): `posts` 

    Column names: `title`, `content`, `views`

## 3. Decide the column types.

[Here's a full documentation of PostgreSQL data types](https://www.postgresql.org/docs/current/datatype.html).

Most of the time, you'll need either `text`, `int`, `bigint`, `numeric`, or `boolean`. If you're in doubt, do some research or ask your peers.

Remember to **always** have the primary key `id` as a first column. Its type will always be `SERIAL`.

```
# EXAMPLE:

Table: user_accounts
id: SERIAL
email: text
username: text

Table: posts
id: SERIAL
title: text
content: text
views: int
```

## 4. Decide on The Tables Relationship

Most of the time, you'll be using a **one-to-many** relationship, and will need a **foreign key** on one of the two tables.

To decide on which one, answer these two questions:

1. Can one user_account have many posts? Yes
2. Can one post have many user_accounts? No

You'll then be able to say that:

1. **[user_accounts] has many [posts]**
2. And on the other side, **[posts] belongs to [user_accounts]**
3. In that case, the foreign key is in the table [posts]

*If you can answer YES to the two questions, you'll probably have to implement a Many-to-Many relationship, which is more complex and needs a third table (called a join table).*

## 4. Write the SQL.

```sql
-- EXAMPLE
-- file: albums_table.sql

-- Replace the table name, columm names and types.

-- Create the table without the foreign key first.
CREATE TABLE user_accounts (
  id SERIAL PRIMARY KEY,
  email text,
  username text
);

-- Then the table with the foreign key first.
CREATE TABLE posts (
  id SERIAL PRIMARY KEY,
  title text,
  content text,
  views int,
-- The foreign key name is always {other_table_singular}_id
  user_account_id int,
  constraint fk_user foreign key(user_account_id)
    references user_accounts(id)
    on delete cascade
);

```

## 5. Create the tables.

```bash
psql -h 127.0.0.1 database_name < albums_table.sql
```