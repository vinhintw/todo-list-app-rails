module Authentication
  extend ActiveSupport::Concern

  included do
    before_action :require_authentication
    before_action :set_current_user
    helper_method :authenticated?, :current_user
  end

  class_methods do
    def allow_unauthenticated_access(**options)
      skip_before_action :require_authentication, **options
    end

    def redirect_authenticated_user(**options)
      before_action :redirect_if_authenticated, **options
    end
  end

  private
    def set_current_user
      Current.user = current_user
    end

    def authenticated?
      current_user.present?
    end

    def current_user
      @current_user ||= User.find(session[:user_id]) if session[:user_id]
    rescue ActiveRecord::RecordNotFound
      session[:user_id] = nil
      nil
    end

    def require_authentication
      authenticated? || request_authentication
    end

    def request_authentication
      session[:return_to_after_authenticating] = request.url
      redirect_to login_path
    end

    def after_authentication_url
      session.delete(:return_to_after_authenticating) || root_url
    end

    def start_new_session_for(user)
      session[:user_id] = user.id
    end

    def terminate_session
      session[:user_id] = nil
    end

    def redirect_if_authenticated
      if authenticated?
        redirect_to root_path, notice: "You are already signed in."
      end
    end

    def redirect_if_unauthenticated
      unless authenticated?
        redirect_to login_path, alert: "Please sign in to continue."
      end
    end
end
