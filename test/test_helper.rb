require 'rubygems'
require 'bundler'
Bundler.setup
Bundler.require :default, :test

require 'test/unit'
require "breadcrumbs"
require 'action_controller'
require 'action_controller/test_case'
require 'active_model/naming'

I18n.load_path << File.dirname(__FILE__) + "/resources/en.yml"
I18n.locale = :en

class TestsController < ActionController::Base
end

class UsersController < ActionController::Base
end

module Admin
  class UsersController < ActionController::Base
  end
end

routes = ActionDispatch::Routing::RouteSet.new
routes.draw do
  resources :tests
  resources :users
  namespace :admin do
    resources :users
  end
end
TestsController.send(:include, routes.url_helpers)

class User
  extend ActiveModel::Naming
  extend ActiveModel::Translation

  def to_param; "123" end
  def name_was; "Sam" end
  def name; "" end
end
