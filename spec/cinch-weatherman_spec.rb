require 'spec_helper'
require 'pp'

describe Cinch::Plugins::Weatherman do

  include Cinch::Test

  before(:each) do
    @bot = make_bot(Cinch::Plugins::Weatherman)
  end

  it 'should allow users to ask for weather by zip' do
     msg = make_message(@bot, '!weather 94062')
     pp get_replies(msg)
     get_replies(msg).last[:text].chomp.
      should include('In Redwood City, CA it is')
  end

  it 'should allow users to ask for weather by city, state' do
     msg = make_message(@bot, '!weather redwood city, ca')
     get_replies(msg).last[:text].chomp.
      should include('In Redwood City, CA it is')
  end

  it 'should allow users to ask for weather by airport code' do
     msg = make_message(@bot, '!weather SFO')
     get_replies(msg).last[:text].chomp.
      should include('In San Francisco International, CA it is')
  end

  it 'should return an error when location not found' do
     msg = make_message(@bot, '!weather 34')
     get_replies(msg).last[:text].chomp.
      should include('Sorry, couldn\'t find 34.')
  end
end
