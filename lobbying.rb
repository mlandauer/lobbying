#!/usr/bin/env ruby
# Downloads data from the Australian Federal Lobbyists Register
#
# Copyright OpenAustralia Foundation
# Licensed under

require 'rubygems'
require 'hpricot'
require 'open-uri'

page = Hpricot(open("http://lobbyists.pmc.gov.au/lobbyistsregister/index.cfm?event=whoIsOnRegister"))

data = []
# Skip first row of table because it contains the headings
page.search("table > tr")[1..-1].each do |row|
  td = row.search("td")
  data << {:entity => (td[1]/"a").inner_text, :trading_name => (td[2]/"a").inner_text, :abn => td[3].inner_text.strip}
end

puts '"Business Entity Name", "Trading Name", ABN'
data.each do |a|
  puts "\"#{a[:entity]}\", \"#{a[:trading_name]}\", #{a[:abn]}"
end
