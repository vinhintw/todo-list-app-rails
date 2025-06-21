class HomeController < ApplicationController
  allow_unauthenticated_access
  layout "home"

  def index
    if authenticated?
      redirect_to tasks_path
    end
  end
end
