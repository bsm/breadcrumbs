require "test_helper"

class BreadcrumbsTest < Test::Unit::TestCase

  def setup
    @controller = TestsController.new
    @controller.request = ActionController::TestRequest.new
    @breadcrumbs = Breadcrumbs.new(@controller)
    @inline = Breadcrumbs::Render::Inline.new(@breadcrumbs)
  end

  def test_return_safe_html
    @breadcrumbs.add "Terms & Conditions"
    assert_equal %(<span class="first last item-0">Terms &amp; Conditions</span>), @breadcrumbs.render(:format => :inline)
  end

  def test_allow_custom_text_escaping
    @breadcrumbs.add "<em>Home</em>".html_safe
    html = @breadcrumbs.render(:format => :inline)
    assert_equal %(<span class="first last item-0"><em>Home</em></span>), html
  end

  def test_add_item
    @breadcrumbs.add "Home"
    assert_equal 1, @breadcrumbs.items.count

    @breadcrumbs << "Home"
    assert_equal 2, @breadcrumbs.items.count
  end

  def test_tag
    assert_equal "<span>Hi!</span>", @inline.tag(:span, "Hi!")
  end

  def test_tag_with_attributes
    expected = %[<span class="greetings" id="hi">Hi!</span>]
    assert_equal expected, @inline.tag(:span, "Hi!", :class => "greetings", :id => "hi")
  end

  def test_tag_with_block
    assert_equal "<span>Hi!</span>", @inline.tag(:span) { "Hi!" }
  end

  def test_tag_with_block_and_attributes
    expected = %[<span class="greetings" id="hi">Hi!</span>]
    assert_equal expected, @inline.tag(:span, :class => "greetings", :id => "hi") { "Hi!" }
  end

  def test_nested_tags
    expected = %[<span class="greetings"><strong id="hi">Hi!</strong></span>]
    actual = @inline.tag(:span, :class => "greetings") { tag(:strong, "Hi!", :id => "hi") }
    assert_equal expected, actual
  end

  def test_render_as_list
    @breadcrumbs.add "Home", "/", :class => "home"
    list = parse_tag(@breadcrumbs.render)
    assert_equal "ul", list.name
    assert_equal "breadcrumbs", list['class']
  end

  def test_render_as_ordered_list
    @breadcrumbs.add "Home", "/"
    list = parse_tag(@breadcrumbs.render(:format => :ordered_list))
    assert_equal "ol", list.name
    assert_equal "breadcrumbs", list['class']
  end

  def test_render_as_list_with_custom_attributes
    @breadcrumbs.add "Home", "/", :class => "home"
    ul = parse_tag(@breadcrumbs.render(:id => "breadcrumbs", :class => "top"))
    assert_equal "ul", ul.name
    assert_equal "top", ul['class']
    assert_equal "breadcrumbs", ul['id']
  end

  def test_render_as_list_add_items
    @breadcrumbs.add "Home", "/", :class => "home"
    @breadcrumbs.add "About", "/about", :class => "about"
    @breadcrumbs.add "People"

    ul = parse_tag(@breadcrumbs.render)
    items = ul.children

    assert_equal 3, items.count

    assert_equal "first item-0", items[0]["class"]
    assert_equal %(<a href="/" class="home">Home</a>), items[0].children.join

    assert_equal "item-1", items[1]["class"]
    assert_equal %(<a href="/about" class="about">About</a>), items[1].children.join

    assert_equal "last item-2", items[2]["class"]
    assert_equal %(<span>People</span>), items[2].children.join
  end

  def test_render_inline
    @breadcrumbs.add "Home", "/", :class => "home"
    item = parse_tag(@breadcrumbs.render(:format => :inline))
    assert_not_equal 'ul', item.name
  end

  def test_render_inline_add_items
    @breadcrumbs.add "Home", "/", :class => "home"
    @breadcrumbs.add "About", "/about", :class => "about"
    @breadcrumbs.add "People"

    items = parse_tags(@breadcrumbs.render(:format => :inline))
    assert_equal 5, items.count

    assert_equal "a", items[0].name
    assert_equal "home first item-0", items[0]["class"]
    assert_equal "Home", items[0].children.join
    assert_equal "/", items[0]["href"]

    assert_equal "span", items[1].name
    assert_equal "separator", items[1]["class"]
    assert_equal "&#187;", items[1].children.join

    assert_equal "a", items[2].name
    assert_equal "about item-1", items[2]["class"]
    assert_equal "About", items[2].children.join
    assert_equal "/about", items[2]["href"]

    assert_equal "span", items[3].name
    assert_equal "separator", items[3]["class"]
    assert_equal "&#187;", items[3].children.join

    assert_equal "span", items[4].name
    assert_equal "last item-2", items[4]["class"]
    assert_equal "People", items[4].children.join
  end

  def test_render_inline_with_custom_separator
    @breadcrumbs.add "Home", "/", :class => "home"
    @breadcrumbs.add "People"

    tags = parse_tags(@breadcrumbs.render(:format => :inline, :separator => "|"))
    assert_equal [
      %(<a href="/" class="home first item-0">Home</a>),
      %(<span class="separator">|</span>),
      %(<span class="last item-1">People</span>)
    ], tags.map(&:to_s)
  end

  def test_render_original_text_when_disabling_translation
    @breadcrumbs.add :home, nil, :i18n => false
    @breadcrumbs.add :people

    items = parse_tag(@breadcrumbs.render).children
    assert_equal "<span>home</span>", items[0].children.join
    assert_equal "<span>Nosso time</span>", items[1].children.join
  end

  def test_render_internationalized_text_using_default_scope
    @breadcrumbs.add :home
    @breadcrumbs.add :people

    items = parse_tag(@breadcrumbs.render).children
    assert_equal "<span>Página inicial</span>", items[0].children.join
    assert_equal "<span>Nosso time</span>", items[1].children.join
  end

  def test_render_scope_as_text_for_missing_scope
    @breadcrumbs.add :contact
    @breadcrumbs.add "Help"

    items = parse_tag(@breadcrumbs.render).children
    assert_equal "<span>contact</span>", items[0].children.join
    assert_equal "<span>Help</span>", items[1].children.join
  end

  def test_pimp_action_controller
    assert @controller.respond_to?(:breadcrumbs)
    assert_equal @controller.breadcrumbs, @controller.breadcrumbs
  end

  def test_escape_text_when_rendering_inline
    @breadcrumbs.add "<script>alert(1)</script>"
    html = @breadcrumbs.render(:format => :inline)

    assert_equal %[<span class="first last item-0">&lt;script&gt;alert(1)&lt;/script&gt;</span>], html
  end

  def test_escape_text_when_rendering_list
    @breadcrumbs.add "<script>alert(1)</script>"
    html = @breadcrumbs.render

    assert_match /&lt;script&gt;alert\(1\)&lt;\/script&gt;/, html
  end

  def test_with_polymorphic_urls
    @breadcrumbs.add "Resources", [:tests]
    prefix  = "#{@controller.request.scheme}://#{@controller.request.host}"
    tag     = parse_tag(@breadcrumbs.render(:format => :inline))

    assert_equal "a", tag.name
    assert_equal "first last item-0", tag['class']
    assert_equal "#{prefix}/tests", tag['href']
    assert_equal "Resources", tag.children.join
  end

  private

    def reject_blanks!(tag)
      tag.children.reject! do |child|
        child.tag? ? (reject_blanks!(child) && false) : child.to_s.blank?
      end
    end

    def parse_tags(html)
      root = HTML::Document.new(html, true, true).root
      reject_blanks!(root)
      root.children
    end

    def parse_tag(html)
      parse_tags(html).first
    end
end
