require "iconv"

class Grundlebox::Util
  
  class << self
    
    # Turns a string into a nice, pretty URL
    def pretty_url(string)
      str_src = Iconv.iconv('ascii//ignore//translit', 'utf-8', string.to_s.downcase) rescue string.to_s.downcase
      return  str_src.
              to_s.
              gsub(/(\s+(and|or|the|go|at|be|to|as|at|is|it|an|of|on|a)\s+)+/, " ").
              gsub(/[^A-Za-z0-9\s]/, "").
              gsub(/\s+/, "_").
              gsub(/\_+/, "_").
              chomp("_").
              split("_")[0,10].
              join("_")
    end
    
    def strip_html(content, allowed=[])
      re = if allowed.any?
        Regexp.new(
          %(<(?!(\\s|\\/)*(#{
            allowed.map {|tag| Regexp.escape( tag.to_s )}.join( "|" )
          })( |>|\\/|'|"|<|\\s*\\z))[^>]*(>+|\\s*\\z)),
          Regexp::IGNORECASE | Regexp::MULTILINE, 'u'
        )
      else
        /<[^>]*(>+|\s*\z)/m
      end
      content.gsub(re,'').gsub(/\s\s+/, " ")
    end
    
  end

end