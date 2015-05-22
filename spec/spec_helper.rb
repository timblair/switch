require "bundler"
Bundler.require(:default, :test)

require_relative "../lib/switch"

module Helpers
  def distinct_random_cards(count = 1)
    Switch::Deck.build.sample(count)
  end
end

RSpec.configure do |c|
  c.include Helpers
end
