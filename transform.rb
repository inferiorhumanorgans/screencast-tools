#!/usr/bin/env ruby

require 'nokogiri'

if ARGV.length != 1
  STDERR.puts "Need an input file"
  exit 1
end

file = ARGV[0]
output = "update-#{File.basename(file, '.bak').sub(/[a-z_]+/, '')}"
output = File.join(File.dirname(file), output)
doc = Nokogiri::XML(File.open(file))

doc.search('style').each do |style|
  text = style.children[0].text.sub(/font-family.*;/, "font-family: 'Fira Code Light';")
  style.children[0].content = text
end

doc.search('text').each do |link|
  link['baseline-shift']='-2.5'
end

File.open(output, "w+") do |f|
  f.write doc
end

puts "output: #{output}"
