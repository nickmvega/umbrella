require "http"
require "json"

gmaps_key = "AIzaSyDKz4Y3bvrTsWpPRNn9ab55OkmcwZxLOHI"

pirate_weather_key = "3RrQrvLmiUayQ84JSxL8D2aXw99yRKlx1N4qFDUE"

gmaps_url = "https://maps.googleapis.com/maps/api/geocode/json?address=#{"Tampa"}&key=#{gmaps_key}"

raw_gmaps_data = HTTP.get(gmaps_url)
parsed_gmaps_data = JSON.parse(raw_gmaps_data)
results = parsed_gmaps_data.fetch("results")
lat = parsed_gmaps_data.fetch("results").at(0).fetch("geometry").fetch("location").fetch("lat")
lng = parsed_gmaps_data.fetch("results").at(0).fetch("geometry").fetch("location").fetch("lng")

pirate_weather_url = "https://api.pirateweather.net/forecast/#{pirate_weather_key}/#{lat},#{lng}"


raw_pirate_weather_data = HTTP.get(pirate_weather_url)

parsed_pirate_weather_data = JSON.parse(raw_pirate_weather_data)

current_data = parsed_pirate_weather_data.fetch("currently")

minutely_hash = parsed_pirate_weather_data.fetch("minutely", false)

all_hourly = parsed_pirate_weather_data.fetch("hourly")

hourly = all_hourly.fetch("data")

next_12_hours = hourly[1..12]

precip_prob_threshold = 0.10

any_precipitation = false

next_12_hours.each do |hour_hash|
  precip_prob = hour_hash.fetch("precipProbability")

  if precip_prob > precip_prob_threshold
    any_precipitation = true

pp next_12_hours

if any_precipitation == true
  puts "You might want to take an umbrella!"
else
  puts "You probably won't need an umbrella."
end
