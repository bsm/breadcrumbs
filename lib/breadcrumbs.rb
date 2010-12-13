require "action_controller"
require "active_support/inflector"

class Breadcrumbs < Array
  autoload :Render, "breadcrumbs/render"
  autoload :Version, "breadcrumbs/version"

  attr_reader :controller

  def initialize(controller) # :nodoc:
    @controller = controller
    super([])
  end

  # Add a new breadcrumbs.
  #
  #   breadcrumbs.add "Home"
  #   breadcrumbs.add "Home", "/"
  #   breadcrumbs.add "Home", "/", :class => "home"
  #
  # If you provide a symbol as text, it will try to
  # find it as I18n scope.
  #
  def add(text, url = nil, options = {})
    options.reverse_merge!(:i18n => true)
    text = translate(text) if options.delete(:i18n)
    url  = controller.__send__(:url_for, url) if url
    push [text.to_s, url, options]
  end
  alias :<< :add

  # Short-cut for adding breadcrumbs. Examples:
  #
  #   breadcrumbs.crumb :posts
  #   # => ["Posts", "/posts"]
  #
  #   breadcrumbs.crumb @post, :comments
  #   # => ["Comments", "/posts/123/comments"]
  #
  #   @user # => #<User name: "Sam">
  #   breadcrumbs.crumb :admin, @account, @user
  #   # => ["Sam", "/admin/accounts/123/users/456"]
  #
  #   breadcrumbs.crumb @post, :comments, :title => "Our Comments"
  #   # => ["Our Comments", "/posts/123/comments"]
  #
  def crumb(*args)
    options = args.extract_options!

    title = if options[:title]
      options.delete(:title)
    else
      case args.last
      when String, Symbol
        infer_model_name_from_symbol(args.last).human(:count => :multiple)
      else
        infer_title_from_record(args.last)
      end
    end
    url = args.presence || false

    add title.presence, options.delete(:url) || url, options
  end

  # Render breadcrumbs using the specified format.
  # Use HTML lists by default, but can be plain links.
  #
  #   breadcrumbs.render
  #   breadcrumbs.render(:format => :inline)
  #   breadcrumbs.render(:format => :inline, :separator => "|")
  #   breadcrumbs.render(:format => :list)
  #   breadcrumbs.render(:format => :ordered_list)
  #   breadcrumbs.render(:id => "breadcrumbs")
  #   breadcrumbs.render(:class => "breadcrumbs")
  #
  # You can also define your own formatter. Just create a class that implements a +render+ instance
  # method and you're good to go.
  #
  #   class Breadcrumbs::Render::Dl
  #     def render
  #       # return breadcrumbs wrapped in a <DL> tag
  #     end
  #   end
  #
  # To use your new format, just provide the <tt>:format</tt> option.
  #
  #   breadcrumbs.render(:format => :dl)
  #
  def render(options = {})
    options[:format] ||= :list

    klass_name = options[:format].to_s.classify
    klass = Breadcrumbs::Render.const_get(klass_name)
    html = klass.new(self, options).render

    html.respond_to?(:html_safe) ? html.html_safe : html
  end

  def translate(scope) # :nodoc:
    text = I18n.t(scope, :scope => :breadcrumbs, :raise => true) rescue nil
    text ||= I18n.t(scope, :default => scope.to_s)
    text
  end

  private

    def infer_model_name_from_symbol(symbol)
      symbol.to_s.classify.constantize.model_name
    end

    def infer_title_from_record(record)
      %w(to_label title_was title name_was name label_was label value_was value to_s).each do |m|
        return record.send(m) if record.respond_to?(m)
      end
    end

end

require "breadcrumbs/action_controller_ext"