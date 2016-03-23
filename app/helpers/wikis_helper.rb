module WikisHelper
  def user_is_authorized?(wiki)
    current_user && (current_user == wiki.user || current_user.admin?)
  end

  def markdown_wiki(text)
    options = {
      filter_html:         true,
      hard_wrap:           true,
      link_attributes:     { rel: "nofollow", target: "_blank" }
    }

    extensions = {
      space_after_headers:          true,
      autolink:                     true,
      superscript:                  true,
      disable_indented_code_blocks: true,
      fenced_code_blocks:           true
    }

    renderer = Redcarpet::Render::HTML.new(options)
    markdown = Redcarpet::Markdown.new(renderer, extensions)

    markdown.render(text).html_safe
  end
end
