require 'rack/utils'

module Madlep
  class MadeInRailscamp
    def initialize(app, message = "<p>I made this at Railscamp after drinking beer and not doing productive stuff</p>")
      @app = app
      @message = message
    end

    def call(env)
      return @app.call(env) unless %w[GET].include?(env['REQUEST_METHOD'])
      
      status, headers, body = @app.call(env)
      
      new_body, new_headers = say_made_at_railscamp!(body, headers)
      
      [status, new_headers, new_body]
    end
    
    private
    def say_made_at_railscamp!(body, headers)

      new_body = []
      new_content_length = 0
      body.each do |body_part|
        new_body_part = body_part.gsub(/<\/body>/, "#{@message}</body>")
        new_body << new_body_part
        new_content_length += Rack::Utils.bytesize(new_body_part)
      end
      
      if headers['Content-Length']
        headers['Content-Length'] = new_content_length.to_s
      end
      
      [new_body, headers]
    end
  end
end
