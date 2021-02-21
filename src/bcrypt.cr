require "crypto/bcrypt/password"

alias BCrypt = Crypto::Bcrypt

class BCrypt::Password
  def self.from_rs(rs : DB::ResultSet)
    new rs.read(String)
  end
end
