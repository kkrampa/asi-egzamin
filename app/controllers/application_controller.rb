class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  before_filter :set_locale

  def set_locale
    I18n.locale = params[:locale] if params[:locale].present?
  end

  def default_url_options
    {locale: I18n.locale}
  end

  protect_from_forgery with: :exception
  include SessionsHelper

  private

    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = t('please_sign_in')
        redirect_to login_url
      end
    end
end
