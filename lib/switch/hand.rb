module Switch
  class Hand < Deck

    def draw(deck, count=1)
      drawn = Deck.new
      count.times do
        card = deck.draw
        drawn << card if card
      end
      push(*drawn)
      drawn
    end

  end
end
