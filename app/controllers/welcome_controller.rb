class WelcomeController < ApplicationController
  skip_before_action :authenticate_user!

  def index
  end

  def auto_sign
    tester = User.find_by(email: "test@test.io")
    sign_in(tester)
    redirect_to root_path
  end
end
