module Responders::JsonResponder
  protected
  # simply render the resource even on POST instead of redirecting for ajax
  def api_behavior(error)
    if post?
      display resource, :status => :created, :location => api_location
    elsif put?
      display resource, :status => :ok, :location => api_location
    else
      super
    end
  end
end

