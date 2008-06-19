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
    @response = stub(:body => '')
    stubs(:request).returns(@request)
    stubs(:response).returns(@response)
    stubs(:performed?)
    stubs(:render)
  end
  
  it "should read from the cache with request uri as key and render that text" do
    @request.stubs(:request_uri).returns('/foo/bar')
    Rails.cache.write('/foo/bar', 'page content')
    expects(:render).with(:text => 'page content')
    render_with_cache
  end
  
  it "should read from the cache with custom passed key and render that text" do
    Rails.cache.write('my_key', 'page content')
    expects(:render).with(:text => 'page content')
    render_with_cache 'my_key'
  end
  
  it "should save response.body to cache as key when not specified" do
    @response.stubs(:body).returns('content')
    render_with_cache 'some_key'
    Rails.cache.read('some_key').should == 'content'
  end
  
  it "should call render when not cached or rendered yet" do
    stubs(:performed?).returns(false)
    expects(:render).with()
    render_with_cache 'some_key'
  end
  
  it "should not call render if already rendered" do
    stubs(:performed?).returns(true)
    stubs(:render).raises('should not be called')
    lambda { render_with_cache 'some_key' }.should_not raise_error
  end
  
  it "should not call render :text if cache doesn't exist" do
    stubs(:render).with(:text => @response.body).raises('should not be called')
    lambda { render_with_cache 'some_key' }.should_not raise_error
  end
  
  it "should yield to block when not cached" do
    pass = false
    render_with_cache('some_key') { pass = true }
    pass.should be_true
  end
  
  it "should not yield to block when cached" do
    Rails.cache.write('some_key', 'page content')
    render_with_cache('some_key') { violated('block was executed') }
  end
  
  it "should pass options to cache write call" do
    Rails.cache.expects(:write).with('some_key', @response.body, :expires_in => 5)
    render_with_cache('some_key', :expires_in => 5)
  end
end
