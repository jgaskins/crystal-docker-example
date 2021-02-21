require "interro"

require "../models/user"

struct UserQuery < Interro::QueryBuilder(User)
  table "users"

  def with_id(id : UUID)
    where(id: id).first
  end

  def with_email(email : String)
    where(email: email).first
  end

  def create(email : String, name : String, password : BCrypt::Password) : User
    insert email: email, name: name, password: password
  end
end
