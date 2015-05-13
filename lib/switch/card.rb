module Switch
  class Card
    include Comparable

    attr_reader :rank, :suit

    RANKS = (2..10).to_a + %w{ Jack Queen King Ace }
    SUITS = %w{ Clubs Diamonds Hearts Spades }.sort
    SYMBOLS = { clubs: "♣", diamonds: "♦", hearts: "♥", spades: "♠" }

    InvalidRankError = Class.new(StandardError)
    InvalidSuitError = Class.new(StandardError)

    def initialize(rank, suit)
      raise InvalidRankError unless RANKS.include?(rank)
      raise InvalidSuitError unless SUITS.include?(suit)
      @rank = rank
      @suit = suit
    end

    def self.random
      new(RANKS.sample, SUITS.sample)
    end

    def <=>(other)
      return nil unless other.class == self.class
      return 0 if rank == other.rank && suit == other.suit
      if rank == other.rank
        SUITS.rindex(suit) < SUITS.rindex(other.suit) ? -1 : 1
      else
        RANKS.rindex(rank) < RANKS.rindex(other.rank) ? -1 : 1
      end
    end

    def to_s
      "#{rank} of #{suit}"
    end

    def symbol
      SYMBOLS[suit.downcase.to_sym]
    end

    def ident
      (rank.is_a?(Fixnum) ? rank.to_s : rank[0]) + symbol
    end
    alias :inspect :ident
  end
end
