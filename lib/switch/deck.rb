module Switch
  class Deck < Array
    ALL_CARDS = Card::RANKS.product(Card::SUITS).map do |rank, suit|
      Switch::Card.new(rank, suit)
    end.freeze

    InvalidCardError = Class.new(StandardError)

    def self.build(cards = ALL_CARDS)
      new.tap { |deck| deck << cards }
    end

    def <<(*cards)
      cards.flatten!
      fail InvalidCardError unless cards.all? { |card| card.is_a?(Card) }
      cards.each { |card| super(card) }
    end

    def match?(other)
      sort == other.sort
    end

    alias_method :draw, :shift
  end
end
