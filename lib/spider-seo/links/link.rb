require 'spider-seo/tag'

module SpiderSeo
  class Document
    class Links
      class Link < SpiderSeo::Document::Tag

        attr_accessor :href
        attr_accessor :text

        # Constructor
        def initialize(name = nil, href = nil, text = nil, attributes = [])
          self.name = name
          self.href = href
          self.text = text
          self.attributes = attributes
        end

        # Determines if self is a link with rel="nofollow" attribute
        def is_no_follow?
          return !self.attributes.select {|att| att.name == 'rel' and att.value == 'nofollow'}.first.nil?
        end
      end
    end
  end
end