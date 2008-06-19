module RenderCaching
  module ControllerAdditions
    private
    
    def render_with_cache(key = nil)
      key ||= request.request_uri
      result = Rails.cache.fetch(key) { response.body }
      render :text => Rails.cache.read(key)
    end
  end
end

class ActionController::Base
  include RenderCaching::ControllerAdditions
end
