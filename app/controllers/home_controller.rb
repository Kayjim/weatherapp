class HomeController < ApplicationController
  def index
    # creates array of states we can choose from
    @states = %w[HI AK CA OR WA ID UT NV AZ NM CO WY MT ND SD NB KS OK TX LA AR MO IA MN WI IL IN MI OH KY TN MS AL GA FL SC NC VA WV DE MD PA NY NJ CT RI MA VT NH ME DC].sort!

    # removes spaces from 2 word city names and replaces with underscore
    params[:city].tr!(' ', '_') unless params[:city].nil?
    # check state and city are not empty
    if params[:state] != '' && !params[:state].nil? && params[:city] != '' && !params[:city].nil?
      response = HTTParty.get("http://api.wunderground.com/api/#{ENV['wunderground_api_key']}/geolookup/conditions/q/#{params[:state]}/#{params[:city]}.json")
    else
      # if empty stats from Charlotte show up
      response = HTTParty.get("http://api.wunderground.com/api/#{ENV['wunderground_api_key']}/geolookup/conditions/q/NC/Charlotte.json")
    end
    # if wrong input stats from Charlotte show up
    if response.dig('location', 'city').nil?
      response = HTTParty.get("http://api.wunderground.com/api/#{ENV['wunderground_api_key']}/geolookup/conditions/q/NC/Charlotte.json")
    end

    @location = response['location']['city']
    @temp_f = response['current_observation']['temp_f']
    @temp_c = response['current_observation']['temp_c']
    @weather_icon = response['current_observation']['icon_url']
    @weather_words = response['current_observation']['weather']
    @forecast_link = response['current_observation']['forecast_url']
    @feels_like_f = response['current_observation']['feelslike_f']
    @feels_like_c = response['current_observation']['feelslike_c']
  end

  def test
    response = HTTParty.get("http://api.wunderground.com/api/#{ENV['wunderground_api_key']}/geolookup/conditions/q/NC/Charlotte.json")

    @location = response['location']['city']
    @temp_f = response['current_observation']['temp_f']
    @temp_c = response['current_observation']['temp_c']
    @weather_icon = response['current_observation']['icon_url']
    @weather_words = response['current_observation']['weather']
    @forecast_link = response['current_observation']['forecast_url']
    @feels_like_f = response['current_observation']['feelslike_f']
    @feels_like_c = response['current_observation']['feelslike_c']
  end
end
