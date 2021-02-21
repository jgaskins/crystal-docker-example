require "armature/route"

struct Signup
  include Armature::Route

  def call(context)
    route context do |r, response, session|
      r.root do
        r.get { render "signup" }
        r.post do
          user = UserQuery.new.create(
            email: r.form_params["email"],
            name: r.form_params["name"],
            password: BCrypt::Password.create(r.form_params["password"], cost: 4),
          )

          session["user_id"] = user.id.to_s
          response.redirect "/"
        end
      end
    end
  end
end
