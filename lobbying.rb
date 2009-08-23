#!/usr/bin/env ruby
# Downloads data from the Australian Federal Lobbyists Register
#
# Copyright OpenAustralia Foundation
# Licensed under

require 'rubygems'
require 'hpricot'
require 'open-uri'

page = Hpricot(open("http://lobbyists.pmc.gov.au/lobbyistsregister/index.cfm?event=whoIsOnRegister"))

puts '"Business Entity Name", "Trading Name", ABN'
# Skip first row of table because it contains the headings
page.search("table > tr")[1..-1].each do |row|
  business_entity_name = (row.search("td")[1]/"a").inner_text
  trading_name = (row.search("td")[2]/"a").inner_text
  abn = row.search("td")[3].inner_text.strip
  puts "\"#{business_entity_name}\", \"#{trading_name}\", #{abn}"
end