module SpiderSeo
  class Document
    class Links
      class Link

        attr_accessor :href
        attr_accessor :text
        attr_accessor :attributes

        # Constructor
        def initialize(href = nil, text = nil, attributes = [])
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