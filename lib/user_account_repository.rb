require_relative 'user_account'

class UserAccountRepository
  def all
    sql = 'SELECT * FROM user_accounts;'
    result = DatabaseConnection.exec_params(sql, [])

    accounts = []
    result.each do |record|
      accounts << record_to_account(record)
    end
    return accounts
  end

  def find(id)
    sql = 'SELECT * FROM user_accounts WHERE id = $1;'
    para =[id]
    result = DatabaseConnection.exec_params(sql, para)
    record = result.first

    record_to_account(record)
  end

  def create(account)
    sql = "INSERT INTO user_accounts (email, username) VALUES 
    ($1, $2);"
    para = [account.email, account.username]
    result = DatabaseConnection.exec_params(sql, para)
    return nil
  end

  def delete(account)
    sql = "DELETE FROM user_accounts WHERE id = $1"
    para = [account.id]
    result = DatabaseConnection.exec_params(sql, para)
    return nil
  end

  def update(account, attr)
    attr_sym = attr.to_sym
    sql = "UPDATE user_accounts SET #{attr} = $1 WHERE id = $2"
    para = [account.send(attr_sym), account.id]
    result = DatabaseConnection.exec_params(sql, para)
    return nil
  end

  private

  def record_to_account(record)
    account = UserAccount.new
    account.id = record['id'].to_i
    account.email = record['email']
    account.username = record['username']
    return account
  end
end