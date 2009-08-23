#!/usr/bin/env ruby
# Downloads data from the Australian Federal Lobbyists Register
#
# Copyright OpenAustralia Foundation
# Licensed under

require 'rubygems'
require 'hpricot'
require 'open-uri'

url = "http://lobbyists.pmc.gov.au/lobbyistsregister/index.cfm"

page = Hpricot(open("#{url}?event=whoIsOnRegister"))

lobbyists = []
# Skip first row of table because it contains the headings
page.search("table > tr")[1..-1].each do |row|
  td = row.search("td")
  lobbyists << {:profile_id => td[0].at("input")["value"], :entity => (td[1]/"a").inner_text,
    :trading_name => (td[2]/"a").inner_text, :abn => td[3].inner_text.strip}
end

# For each lobbyist get their clients and output the result
puts '"Business Entity Name", "Trading Name", ABN, Clients'
lobbyists.each do |l|
  page = Hpricot(open("#{url}?event=viewProfile&profileID=#{l[:profile_id]}"))
  clients = []
  page.search("table")[5].search("tr")[1..-2].each do |tr|
    clients << tr.search("td")[1].inner_text.strip
  end

  clients_with_quotes = clients.map{|c| "\"#{c}\""}
  puts "\"#{l[:entity]}\", \"#{l[:trading_name]}\", #{l[:abn]}, #{clients_with_quotes.join(', ')}"
end
