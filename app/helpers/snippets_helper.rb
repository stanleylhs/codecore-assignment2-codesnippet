# == Schema Information
#
# Table name: snippets
#
#  id         :integer          not null, primary key
#  title      :string
#  work       :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  kind_id    :integer
#  user_id    :integer
#

class CodeRayify < Redcarpet::Render::HTML
  def block_code(code, language)
    CodeRay.scan(code, language).div(line_numbers: :table)
  end
end

module SnippetsHelper
  def markdown(text)
    options = {
      filter_html:     true,
      hard_wrap:       true
      # link_attributes: { rel: 'nofollow', target: "_blank" }
      # space_after_headers: true
      # prettify: true
    }

    extensions = {
      fenced_code_blocks: true,
      no_intra_emphasis: true,
      autolink: true,
      strikethrough: true,
      lax_spacing: true,
      superscript: true
    }

    # renderer = Redcarpet::Render::HTML.new(options)
    coderayified = CodeRayify.new(options)
    markdown = Redcarpet::Markdown.new(coderayified, extensions)

    markdown.render(text).html_safe
  end
end
