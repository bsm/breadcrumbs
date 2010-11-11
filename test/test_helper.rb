require 'rubygems'
require 'bundler'
Bundler.setup
Bundler.require :default, :test

require 'test/unit'
require "breadcrumbs"
require 'action_controller'
require 'action_controller/test_case'
require 'mocha'

I18n.load_path << File.dirname(__FILE__) + "/resources/pt.yml"
I18n.locale = :pt

class TestsController < ActionController::Base
end

if ActionPack::VERSION::MAJOR == 3
  routes = ActionDispatch::Routing::RouteSet.new
  routes.draw do
    resources :tests
  end
  TestsController.send(:include, routes.url_helpers)
else
  ActionController::Routing::Routes.draw do |map|
    map.resources :tests
  end
end
