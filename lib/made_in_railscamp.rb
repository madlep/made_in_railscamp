module Madlep
  class MadeInRailscamp
    def initialize(app, message = "<p>I made this at Railscamp after drinking beer and not doing productive stuff</p>")
      @app = app
      @message = message
    end

    def call(env)
      return @app.call(env) unless %w[GET].include?(env['REQUEST_METHOD'])

      status, headers, body = @app.call(env)
      puts headers.inspect
      body.body.gsub!(/<\/html>/, "#{@message}</html>")
      
      content_length = headers['Content-Length']
      
      if content_length
        length = content_length.to_i
        length += @message.length
        headers['Content-Length'] = length.to_s
      end
      
      [status, headers, body]
    end
  end
end
