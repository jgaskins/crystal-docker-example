require "db"

require "../bcrypt"

struct User
  include DB::Serializable

  getter id : UUID
  getter email : String
  getter name : String
  @[DB::Field(converter: BCrypt::Password)]
  getter password : BCrypt::Password
end
