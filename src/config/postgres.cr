require "interro"
require "dotenv"
Dotenv.load rescue nil # This file may not exist in prod

Interro.config do |c|
  c.db = DB.open(ENV["DATABASE_URL"])
end
