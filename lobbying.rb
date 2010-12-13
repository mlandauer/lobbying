#!/usr/bin/env ruby
#
# Downloads data from the Australian Federal Lobbyists Register and output
# as a "comma separated values" (CSV) file to load into a spreadsheet
# Copyright (C) 2009 OpenAustralia Foundation
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# Author: Matthew Landauer
#
# This code brought to you by the following conversation at 10:25am, Sunday morning, 23 August 2009:
# Kat Szuminska: "How about we submit a Perl app to the taskforce as an essay in transparency?"
# Matthew Landauer: "Okay... but I'll write it in Ruby"

require 'rubygems'
require 'hpricot'
require 'open-uri'
require 'csv'

base_url = "http://lobbyists.pmc.gov.au/"

page = Hpricot(open("#{base_url}who_register.cfm"))

lobbyists = []
page.search("table > tbody > tr").each do |row|
  td = row.search("td")
  lobbyists << {
    :id => td[1].at("a")['href'][28..-1],
    :entity_name => td[1].inner_text,
    :trading_name => td[2].inner_text,
    :abn => td[3].inner_text
  }
end

CSV.open("lobbying.csv", "w") do |f|
  f <<  ["Agency ID", "Business Entity Name", "Trading Name", "ABN", "Clients"]
# For each lobbyist get their clients and output the result
  lobbyists.each do |l|
    page = Hpricot(open("#{base_url}register/view_agency.cfm?id=#{l[:id]}"))

    clients = []
    page.search("table > tbody > tr").each do |row|
      td = row.search("td")
      clients << td[1].inner_text
    end

    #TODO: Owners and lobbyist
    f << [l[:id], l[:entity_name], l[:trading_name], l[:abn]] + clients
  end
end
