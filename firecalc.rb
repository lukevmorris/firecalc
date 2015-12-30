require "rubygems"
require "json"
require "uri"
require "curb"

default_data = JSON.load(File.open("./default.json"))
config_data = JSON.load(File.open("./config.json"))
form_data = default_data.merge(config_data)

payload = URI.encode_www_form(form_data)
response = Curl.post("http://www.firecalc.com/firecalcresults.php", payload).body.gsub(/\s+/," ")

count = response.scan(/(\d+) cycles/).flatten[0]
low, high, avg = response.scan(/\$(-?[\d,]+)/).flatten.map{|dol| dol.gsub(",","")}[1..-1].map{|dol| (dol.to_f / 1_000_000).round(2) }
win_pct = response.scan(/rate of ([\d.%]+)\./).flatten[0]

puts "#{count} cycles"
puts "High: $#{high}M"
puts "Low: $#{low}M"
puts "Avg: $#{avg}M"
puts "Success rate: #{win_pct}"
