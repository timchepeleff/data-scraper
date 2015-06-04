require 'open-uri'
require 'Nokogiri'
require 'pry'

doc = Nokogiri::HTML(open("http://www.goodhousekeeping.com/appliances/coffee-maker-reviews/"))

File.open("file.txt", "w") do |f|
  f.puts(doc)
end

def strip_delimeters(doc, open, close)
  is_tag = false
  tag = ''
  tags = []
  doc = doc.to_s
  doc.each_char do |c|
   is_tag = true if c == open
   tag += c if is_tag == true
   if c == close
     is_tag = false
     tags << tag.clone
     tag = ''
   end
  end
  tags.each do |tag|
   doc.gsub!(tag,'')
  end
  doc
end

def strip_reviews(doc)
  doc.gsub!(/\d{2}\/\d{2}\/\d{2}/,'------')
  doc.split('------')
end

def parse_reviews(doc)
  doc.each_index do |i|
    doc[i].gsub!(/\#\d+/, " ")
  end
end

def remove_whitespace(doc)
  doc.gsub!(/\n/,'')
  doc.gsub!(/\r/,'')
  doc.gsub!(/\s+/,' ')
  doc.gsub(/\b/,'')
end

def display_docs(doc)
  doc.each do |review|
    puts review
    puts
  end
end

doc = strip_delimeters(doc, '<', '>')
doc = remove_whitespace(doc)
doc = strip_delimeters(doc, '{', '}')
doc = strip_reviews(doc)
doc = parse_reviews(doc)
doc.shift
doc.pop
display_docs(doc)
