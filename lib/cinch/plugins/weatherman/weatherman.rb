# -*- coding: utf-8 -*-
require 'cinch'
require 'cinch/cooldown'
require 'time-lord'
require 'weather-underground'

module Cinch::Plugins
  class Weatherman
    include Cinch::Plugin

    enforce_cooldown

    self.help = "Use .w <location> to see information on the weather. (e.g. .w 94062)"

    match /w (.*)/
    match /weather (.*)/

    def execute(m, query)
      m.reply get_weather(query)
    end

    private

    def get_weather(query)
      location, temp_f, conditions, updated = get_forcast(query)

      message = "In #{location} it is #{conditions} "
      message << "and #{temp_f}°F "
      message << "(last updated about #{updated})"

      return message
    rescue ArgumentError
      return "Sorry, couldn't find #{query}."
    end

    def get_forcast(query)
      data = WeatherUnderground::Base.new.CurrentObservations(query)
      weather = [ data.display_location.first.full,
                  data.temp_f,
                  data.weather.downcase,
                  Time.parse(data.observation_time).ago.to_words ]
      return weather
    end
  end
end
