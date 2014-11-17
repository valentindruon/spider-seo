module SpiderSeo
  class Document
    class Tag
      attr_accessor :name
      attr_accessor :text
      attr_accessor :attributes
      attr_accessor :children

      # Constructor
      def initialize name = nil, text = nil, attributes = [], children = []
        self.name = name
        self.text = text
        self.attributes = attributes
        self.children = children
      end
    end
  end
end