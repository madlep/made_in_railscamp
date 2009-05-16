require File.dirname(__FILE__) + '/spec_helper'
require 'made_in_railscamp'

describe Madlep::MadeInRailscamp do
  
  before(:each) do
    @env = {'REQUEST_METHOD' => 'GET'}
    
    @status = "200"
    @body = [
      "<html>\n", 
        "\t<head><title>my awesome app</title></head>\n", 
        "\t<body>\n", 
          "\t\t<h1>I rock!</h1>\n", 
        "\t</body>\n",
      "</html>"]
     
    @headers = {}
    @app = "ultra cool app from Railscamp stub"
    stub(@app).call(@env) { [@status, @headers, @body] }
    
    @mirc = Madlep::MadeInRailscamp.new(@app)
    
    @expected_tweaked_body = [
      "<html>\n", 
        "\t<head><title>my awesome app</title></head>\n", 
        "\t<body>\n", 
          "\t\t<h1>I rock!</h1>\n", 
        "\t<p>I made this at Railscamp after drinking beer and not doing productive stuff</p></body>\n",
      "</html>"]
  end
  
  it "should actually let your app do something, and pass the request to it" do
    mock(@app).call(@env) { [@status, @headers, @body] }
    @mirc.call(@env)
  end
  
  it "should add a friendly little message about where you made this app" do
    new_status, new_headers, new_body = @mirc.call(@env)
    new_body.should == @expected_tweaked_body
  end
  
  describe "http methods" do
    it "should fuzz with the html output for GET requests" do
      @env['REQUEST_METHOD'] = 'GET'
      new_status, new_headers, new_body = @mirc.call(@env)
      new_body.should_not == @body
    end
    
    it "shouldn't fuzz with the html output for POST requests" do
      @env['REQUEST_METHOD'] = 'POST'
      new_status, new_headers, new_body = @mirc.call(@env)
      new_body.should == @body
    end
  end
  
  describe "content length" do
    it "should figure out the new content length when it changes the body" do      
      new_length = @expected_tweaked_body.inject(0){|length, body_part| length + Rack::Utils.bytesize(body_part)}
      
      @headers['Content-Length'] = 1234
      
      new_status, new_headers, new_body = @mirc.call(@env)
      
      new_headers['Content-Length'].should == new_length.to_s
    end
    
    it "should not set the content length, if it wasnt' set in the original request" do
      @headers.delete('Content-Length')
      
      new_status, new_headers, new_body = @mirc.call(@env)
      
      new_headers['Content-Length'].should be_nil
    end
  end
  
end
