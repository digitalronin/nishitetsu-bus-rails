class ApplicationController < ActionController::Base
  around_action :switch_locale

  def switch_locale(&action)
    locale = params[:locale] || I18n.default_locale
    @path_without_locale = path_without_locale
    I18n.with_locale(locale, &action)
  end

  def default_url_options
    { locale: params[:locale] || I18n.locale }
  end

  private

  def path_without_locale
    request.env['PATH_INFO'].sub(/^\/\w\w\//, '')
  end
end
