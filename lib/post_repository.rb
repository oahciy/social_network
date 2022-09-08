require_relative 'post'

class PostRepository
  def all
    sql = 'SELECT * FROM posts;'
    result = DatabaseConnection.exec_params(sql, [])

    posts = []
    result.each do |record|
      posts << record_to_post(record)
    end
    return posts
  end

  def find(id)
    sql = 'SELECT * FROM posts WHERE id = $1;'
    para =[id]
    result = DatabaseConnection.exec_params(sql, para)
    record = result.first

    record_to_post(record)
  end

  def create(post)
    sql = "INSERT INTO posts (title, content, views, user_account_id) VALUES 
    ($1, $2, $3, $4);"
    para = [post.title, post.content, post.views, post.user_account_id]
    result = DatabaseConnection.exec_params(sql, para)
    return nil
  end

  def delete(post)
    sql = "DELETE FROM posts WHERE id = $1"
    para = [post.id]
    result = DatabaseConnection.exec_params(sql, para)
    return nil
  end

  def update(post, attr)
    attr_sym = attr.to_sym
    sql = "UPDATE posts SET #{attr} = $1 WHERE id = $2"
    para = [post.send(attr_sym), post.id]
    result = DatabaseConnection.exec_params(sql, para)
    return nil
  end

  private

  def record_to_post(record)
    post = Post.new
    post.id = record['id'].to_i
    post.title = record['title']
    post.content = record['content']
    post.views = record['views'].to_i
    post.user_account_id = record['user_account_id'].to_i
    return post
  end
end