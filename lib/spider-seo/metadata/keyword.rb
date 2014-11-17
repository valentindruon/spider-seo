module SpiderSeo
  class Document
    class Metadata
      class Keyword

        # Accessors for word
        attr_accessor :word
        # Accessors for self.word occurences count
        attr_accessor :count
        # Accessord for document
        attr_accessor :document

        # Constructor
        def initialize doc = nil
          self.document = doc
          count_occurences if self.document
        end

        # Count self.word occurences in self.document
        def count_occurences
          text = self.document.xpath("//text()").to_s
          words = text.split(/\s+/)
          return words.select {|w| w == self.word }.size
        end
      end
    end
  end
end