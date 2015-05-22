module Switch
  class Card
    include Comparable

    attr_reader :rank, :suit

    RANKS = (2..10).to_a + %w( Jack Queen King Ace ).freeze
    SUITS = %w( Clubs Diamonds Hearts Spades ).sort.freeze
    SYMBOLS = { clubs: "♣", diamonds: "♦", hearts: "♥", spades: "♠" }.freeze

    InvalidRankError = Class.new(StandardError)
    InvalidSuitError = Class.new(StandardError)

    def initialize(rank, suit)
      fail InvalidRankError unless RANKS.include?(rank)
      fail InvalidSuitError unless SUITS.include?(suit)
      @rank = rank
      @suit = suit
    end

    def self.random
      new(RANKS.sample, SUITS.sample)
    end

    def <=>(other)
      return nil unless other.is_a? Card
      return 0 if ident == other.ident
      return suit_value < other.suit_value ? -1 : 1 if rank == other.rank
      rank_value < other.rank_value ? -1 : 1
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
    alias_method :inspect, :ident

    def rank_value
      RANKS.rindex(rank) + 2
    end

    def suit_value
      SUITS.rindex(suit)
    end
  end
end
