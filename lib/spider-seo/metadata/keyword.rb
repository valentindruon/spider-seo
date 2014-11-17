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
        def initialize word, doc = nil
          self.word = word
          self.document = doc
          self.count = count_occurences if self.document
        end

        # Count self.word occurences in self.document
        def count_occurences
          self.document.search('script').each {|el| el.unlink} # Remove all script tags
          self.document.search('style').each {|el| el.unlink} # Remove all style tags
          self.document.text.downcase.scan(/#{self.word.downcase}/).count
        end

        # to_s override
        def to_s
          "#{self.word} - #{self.count}"
        end
      end
    end
  end
end