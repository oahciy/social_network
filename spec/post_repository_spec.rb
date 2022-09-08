require 'post_repository'

RSpec.describe PostRepository do

  def reset_post_table
    seed_sql = File.read('spec/seeds.sql')
    connection = PG.connect({ host: '127.0.0.1', dbname: 'social_network_test' })
    connection.exec(seed_sql)
  end

  before(:each) do 
    reset_post_table
  end

  it "gets all posts and returns in an array" do
    repo = PostRepository.new
    posts = repo.all
    expect(posts.length).to eq 2
    expect(posts[0].title).to eq 'title_1'
    expect(posts[0].content).to eq 'content_1'
    expect(posts[0].views).to eq 10
    expect(posts[0].user_account_id).to eq 1
    expect(posts[1].title).to eq 'title_2'
    expect(posts[1].content).to eq 'content_2'
    expect(posts[1].views).to eq 2
    expect(posts[1].user_account_id).to eq 2
  end

  it "finds post by its id" do
    repo = PostRepository.new
    post = repo.find(1)
    expect(post.title).to eq 'title_1'
    expect(post.content).to eq 'content_1'
  end

  it "creates a new account" do
    repo = PostRepository.new
    post = Post.new
    post.id = 3
    post.title = 'title_3'
    post.content = 'content_3'
    post.views = 200
    post.user_account_id = 1

    repo.create(post)
    posts = repo.all
    expect(posts.last.id).to eq 3
    expect(posts.last.title).to eq 'title_3'
    expect(posts.last.content).to eq 'content_3'
    expect(posts.last.views).to eq 200
    expect(posts.last.user_account_id).to eq 1
  end

  it "deletes a post" do
    repo = PostRepository.new
    post_to_delete = repo.all[1]
    repo.delete(post_to_delete)
    expect(repo.all.last.title).to eq 'title_1'
  end

  it "updates a specific record" do
    repo = PostRepository.new
    post_to_update = repo.all[0]
    post_to_update.content = 'yichao'
    repo.update(post_to_update, 'content')
    expect(repo.find(post_to_update.id).content).to eq 'yichao'
  end
end