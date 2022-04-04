#!/usr/bin/env ruby

require 'nokogiri'

if ARGV.length != 2
  STDERR.puts "Need an input file and DPI"
  exit 1
end

CAST_BASE=ARGV[0]
DPI=ARGV[1].to_i
DEFAULT_DPI=96

file = "#{CAST_BASE}/termtosvg_00000.svg"
doc = Nokogiri::XML(File.open(file))
svg = doc.xpath('/xmlns:svg/xmlns:svg')[0]
width = svg['width'].to_i
height = svg['height'].to_i

def will_work(width, height, dpi)
  output_width = (width.to_f * (dpi/DEFAULT_DPI.to_f)).round
  output_height = (height.to_f * (dpi/DEFAULT_DPI.to_f)).round
  
  if ((output_width % 2)) > 0 or ((output_height % 2) > 0) or (output_width == 0) or (output_height ==0)
    false
  else
    true
  end
end

if not will_work(width, height, DPI)
  lower=will_work(width, height, DPI - 1)
  upper=will_work(width, height, DPI + 1)
  puts "#{DPI} dpi won't work for video output."
  if lower == true
    puts "#{DPI - 1} dpi will work."
  end
  if upper == true
    puts "#{DPI + 1} dpi will work."
  end
  exit 1
end
