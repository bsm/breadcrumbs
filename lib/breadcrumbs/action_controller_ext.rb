class Breadcrumbs
  module ActionController # :nodoc: all
    extend ActiveSupport::Concern

    included do
      helper_method :breadcrumbs
    end

    def breadcrumbs
      @breadcrumbs ||= Breadcrumbs.new(self)
    end

  end
end

ActionController::Base.send :include, Breadcrumbs::ActionController
