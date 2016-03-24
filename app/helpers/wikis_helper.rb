module WikisHelper
  def user_is_authorized?(wiki)
    current_user && (current_user == wiki.user || wiki.collaborators.pluck(:user_id).include?(current_user.id) || current_user.admin?)
  end

  def owner_or_admin(wiki)
    current_user == wiki.user || current_user.admin?
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

  def display_collaborators(collaborators)
    raw collaborators.map {|c| link_to User.find(c.user_id).email, '#',  class: 'btn-xs btn-primary' }.join(' ')
  end
end
