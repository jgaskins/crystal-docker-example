require "armature/route"

struct Login
  include Armature::Route

  def call(context)
    route context do |r, response, session|
      r.root do
        r.get { render "login" }
        r.post do
          if (user = UserQuery.new.with_email(r.form_params["email"])) && user.password.verify(r.form_params["password"])
            session["user_id"] = user.id.to_s
            response.redirect "/"
          else
            render "login"
          end
        end
      end
    end
  end
end
