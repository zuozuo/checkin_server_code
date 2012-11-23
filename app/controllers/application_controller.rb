class ApplicationController < ActionController::Base
  include Restable
  protect_from_forgery
  respond_to :html, :xml, :json, :js
  responders :flash, :http_cache

  before_filter :authenticate_user!
  skip_before_filter  :verify_authenticity_token
end
