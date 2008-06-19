module RenderCaching
  module ControllerAdditions
    private
    
    def render_with_cache(key = nil)
      key ||= request.request_uri
      body = Rails.cache.read(key)
      if body
        render :text => body
      else
        yield if block_given?
        render unless performed?
        Rails.cache.write(key, response.body)
      end
    end
  end
end

class ActionController::Base
  include RenderCaching::ControllerAdditions
end
