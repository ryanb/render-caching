require File.dirname(__FILE__) + '/../spec_helper'

# stub the Rails module functionality
RAILS_CACHE = ActiveSupport::Cache.lookup_store(:memory_store)
module Rails
  def self.cache
    RAILS_CACHE
  end
end

describe ActionController::Base do
  it "should have render_with_cache private method" do
    ActionController::Base.new.private_methods.should include('render_with_cache')
  end
end


describe RenderCaching::ControllerAdditions do
  include RenderCaching::ControllerAdditions
  
  before(:each) do
    Rails.cache.clear
    @request = stub
    @response = stub
    stubs(:request).returns(@request)
    stubs(:response).returns(@response)
    stubs(:render)
  end
  
  it "should read from the cache with request uri as key and render that text" do
    @request.stubs(:request_uri).returns('/foo/bar')
    Rails.cache.write('/foo/bar', 'page content')
    expects(:render).with(:text => 'page content')
    render_with_cache
  end
  
  it "should read from the cache with custom passed key and render that text" do
    @request.stubs(:request_uri).returns('my_key')
    Rails.cache.write('my_key', 'page content')
    expects(:render).with(:text => 'page content')
    render_with_cache 'my_key'
  end
  
  it "should save response.body to cache as key when not specified" do
    @response.stubs(:body).returns('content')
    render_with_cache 'some_key'
    Rails.cache.read('some_key').should == 'content'
  end
end
