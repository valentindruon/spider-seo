require 'spider-seo/utils'

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
          self.wrappers = get_wrappers
        end

        # Count self.word occurences in self.document
        # If tag specified, only look for self.word that are wrapped in tag
        # Else look in all document
        def count_occurences(tag = nil)
          if tag
            self.document.xpath("/html//#{tag}[contains(translate(text(), 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz'),'#{self.word.downcase}')]").size
          else
            doc = self.document.clone
            doc.search('script').each {|el| el.unlink}
            doc.search('style').each {|el| el.unlink}
            doc.text.downcase.scan(self.word.downcase).size
          end
        end

        # Get self.word html wrappers (example: the word "Lorem" is contained in <p>, <strong> and <h1>)
        def get_wrappers
          query = "/html//*[contains(translate(text(), 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz'),'#{self.word.downcase}')]"
          SpiderSeo::Utils::xpath(self.document, query)
        end

        # to_s override
        def to_s
          "#{self.word} - #{self.count}"
        end
      end
    end
  end
end