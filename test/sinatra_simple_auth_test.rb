require File.dirname(__FILE__) + '/sinatra_modular_app'
require 'test/unit'
require 'rack/test'
begin; require 'turn/autorun'; rescue LoadError; end

class SinatraSimpleAuthTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    SinatraModularApp
  end

  def test_it_should_login_and_redirect_home
    post '/login', :password => app.password, :username => app.username
    assert_redirected_to app.home
  end

  def test_it_should_fail_login_with_incorrect_password_and_username_and_redirect_back_to_form
    post '/login', :password => 'incorrect', :username => 'non existing'
    assert_redirected_to '/login'
  end

  def test_it_should_fail_login_with_incorrect_password_and_redirect_back_to_form
    post '/login', :password => 'incorrect', :username => app.username
    assert_redirected_to '/login'
  end

  def test_it_should_fail_login_with_incorrect_username_and_redirect_back_to_form
    post '/login', :password => app.password, :username => 'non existing'
    assert_redirected_to '/login'
  end

  def test_it_should_login_and_redirect_back
    get '/pvt'
    assert_redirected_to '/login'

    login!
    assert_redirected_to '/pvt'
  end

  def test_it_should_logout_via_delete
    login!
    delete '/logout'
    assert_redirected_to '/'
  end

  def test_it_should_logout_via_get
    login!
    get '/logout'
    assert_redirected_to '/'
  end

  def test_authorized_helper_should_work
    get '/public'
    assert last_response.body.include?("Please login")

    login!
    get '/public'
    assert last_response.body.include?(app.username)
  end

  protected
  def login!
    post '/login', :password => app.password, :username => app.username
  end

  def assert_redirected_to(path)
    assert last_response.redirect?
    assert_equal path, last_response.headers['Location'].sub('http://example.org', '')
  end
end