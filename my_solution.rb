require "http"
require "json"
require 'ascii_charts'

gmaps_key = "AIzaSyDKz4Y3bvrTsWpPRNn9ab55OkmcwZxLOHI"

pirate_weather_key = "3RrQrvLmiUayQ84JSxL8D2aXw99yRKlx1N4qFDUE"


puts "-" * 50
puts "Will you need an umbrella today?".center(50)
puts "-" * 50

puts "Where are you currently located?"
#Ask the user for their location.
user_location = gets.chomp
puts "Checking the weather at #{user_location}...."

#gmaps url
gmaps_url = "https://maps.googleapis.com/maps/api/geocode/json?address=#{user_location}&key=#{gmaps_key}"
#raw GMAPS data
raw_gmaps_data = HTTP.get(gmaps_url)
#parse GMAPS data
parsed_gmaps_data = JSON.parse(raw_gmaps_data)
#result table
results = parsed_gmaps_data.fetch("results")
#lat
lat = parsed_gmaps_data.fetch("results").at(0).fetch("geometry").fetch("location").fetch("lat")
#lng
lng = parsed_gmaps_data.fetch("results").at(0).fetch("geometry").fetch("location").fetch("lng")

puts "Your coordinates are #{lat}, #{lng}."

#pirate weather url
pirate_weather_url = "https://api.pirateweather.net/forecast/#{pirate_weather_key}/#{lat},#{lng}"

raw_pirate_weather_data = HTTP.get(pirate_weather_url)

parsed_pirate_weather_data = JSON.parse(raw_pirate_weather_data)

current_data = parsed_pirate_weather_data.fetch("currently")

temp = current_data.fetch("temperature")

#Current Temp
puts "It is currently #{temp}°F."

#Display summary of the weather for the next hour.
next_60_minutes = parsed_pirate_weather_data.fetch("minutely", false)

summary_60_minutes = next_60_minutes.fetch("summary")

puts "Next hour: #{summary_60_minutes}"

all_hourly = parsed_pirate_weather_data.fetch("hourly")

hourly = all_hourly.fetch("data")

next_12_hours = hourly[1..12]

precip_prob_threshold = 0.10

any_precipitation = false

list_of_precipitation = []
count = 1

next_12_hours.each do |hour_hash|
  precip_prob = hour_hash.fetch("precipProbability")

  if precip_prob > precip_prob_threshold
    any_precipitation = true
  end

  list_of_precipitation << [count, precip_prob]
  count += 1
end

# Draw the chart
puts AsciiCharts::Cartesian.new(list_of_precipitation, :title => '12 Hours from now vs Precipitation probability').draw

if any_precipitation == true
  puts "You might want to take an umbrella!"
else
  puts "You probably won't need an umbrella."
end
