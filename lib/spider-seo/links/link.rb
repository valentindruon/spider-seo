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
      end
    end
  end
end