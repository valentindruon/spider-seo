module SpiderSeo
  class Document
    class Metadata
      class Keyword

        # Accessors for word
        attr_accessor :word
        # Accessors for self.word occurences count
        attr_accessor :count
        # Accessors for document
        attr_accessor :document
        # Accessors for wrappers
        attr_accessor :wrappers

        # Constructor
        def initialize word, doc = nil
          self.word = word
          self.document = doc
          self.count = count_occurences if self.document
        end

        # Count self.word occurences in self.document
        def count_occurences(tag = nil)
          if tag
            self.document.xpath("/html//#{tag}[contains(text(),'#{self.word.downcase}')]").size
          else
            self.document.search('script').each {|el| el.unlink}
            self.document.search('style').each {|el| el.unlink}
            self.document.text.downcase.scan(self.word.downcase).size
          end
        end

        # Get self.word html wrapper (example: the word "Lorem" is contained in <p>, <strong> and <h1>)
        def wrappers
          self.document.xpath("/html//*[contains(text(),'#{self.word}')]")
        end

        # to_s override
        def to_s
          "#{self.word} - #{self.count}"
        end
      end
    end
  end
end