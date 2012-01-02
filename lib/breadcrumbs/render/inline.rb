class Breadcrumbs
  module Render
    class Inline < Base # :nodoc: all

      # @overload
      def default_options
        super.merge(:separator => "&#187;")
      end

      # @overload
      def render
        html = []
        size = breadcrumbs.size

        breadcrumbs.each_with_index do |item, i|
          html << render_item(item, i, size)
        end

        separator = tag(:span, options[:separator], :class => "separator")

        html.join(" #{separator} ")
      end

      def render_item(item, i, size)
        text, url, options = *item
        options[:class] ||= ""

        css = []
        css << "first" if i == 0
        css << "last" if i == size - 1
        css << "item-#{i}"

        options[:class] << " #{css.join(" ")}"
        options[:class].gsub!(/^ *(.*?)$/, '\\1')

        wrap_item(url, escape(text), options)
      end
    end
  end
end
