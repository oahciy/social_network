require 'user_account_repository'

RSpec.describe UserAccountRepository do

  def reset_user_account_table
    seed_sql = File.read('spec/seeds.sql')
    connection = PG.connect({ host: '127.0.0.1', dbname: 'social_network_test' })
    connection.exec(seed_sql)
  end

  before(:each) do 
    reset_user_account_table
  end

  it "gets all user accounts and returns in an array" do
    repo = UserAccountRepository.new
    user_accounts = repo.all
    expect(user_accounts.length).to eq 2
    expect(user_accounts[0].email).to eq 'yq2550@gmail.com'
    expect(user_accounts[0].username).to eq 'oahciy'
    expect(user_accounts[1].email).to eq 'givemeanaddress@outlook.com'
    expect(user_accounts[1].username).to eq 'mystery'
  end

  it "finds user account by its id" do
    repo = UserAccountRepository.new
    account = repo.find(1)
    expect(account.email).to eq 'yq2550@gmail.com'
    expect(account.username).to eq 'oahciy'
  end

  it "creates a new account" do
    repo = UserAccountRepository.new
    account = UserAccount.new
    account.id = 3
    account.email = 'newemail@yahoo.com'
    account.username = 'hoo'
    repo.create(account)
    accounts = repo.all
    expect(accounts.last.id).to eq 3
    expect(accounts.last.email).to eq 'newemail@yahoo.com'
    expect(accounts.last.username).to eq 'hoo'
  end

  it "deletes an account" do
    repo = UserAccountRepository.new
    account_to_delete = repo.all[1]
    repo.delete(account_to_delete)
    expect(repo.all.last.email).to eq 'yq2550@gmail.com'
  end

  it "updates a specific record" do
    repo = UserAccountRepository.new
    account_to_update = repo.all[0]
    account_to_update.username = 'yichao'
    repo.update(account_to_update, 'username')
    expect(repo.find(account_to_update.id).username).to eq 'yichao'
  end
end