require "http"
require "armature"
require "armature/redis_session"

require "./config/postgres"
require "./config/redis"

require "./routes/login"
require "./routes/signup"
require "./queries/user"

class App
  include HTTP::Handler
  include Armature::Route

  def call(context)
    route context do |r, response, session|
      if current_user_id = session["user_id"]?.try(&.as_s?)
        current_user = UserQuery.new.with_id(UUID.new(current_user_id))
      end

      render "app_header"

      r.root { render "homepage" }
      r.on "login" { Login.new.call context }
      r.on "signup" { Signup.new.call context }
      r.on "logout" do
        session.delete "user_id"
        response.redirect "/"
      end
      r.miss { render "not_found" }

      render "app_footer"
    end
  end
end

class HealthCheck
  include HTTP::Handler

  def initialize(@path : String)
  end

  def call(context)
    if context.request.resource == @path
      context.response << "All good!"
    else
      call_next context
    end
  end
end

http = HTTP::Server.new([
  HealthCheck.new("/health"),
  HTTP::LogHandler.new,
  HTTP::CompressHandler.new,
  Armature::Session::RedisStore.new(
    key: "app_session",
    redis: REDIS,
  ),
  App.new,
])

port = ENV.fetch("PORT", "5000").to_i
Log.for(App).info { "Listening on port #{port}..." }
http.listen port
