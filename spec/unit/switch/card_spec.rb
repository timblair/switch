require_relative "../../spec_helper"

describe Switch::Card do
  describe "#initialize" do
    let(:card) { described_class.new(rank, suit) }
    let(:rank) { "Ace" }
    let(:suit) { "Spades" }

    context "with a valid card" do
      it "has the correct rank" do
        expect(card.rank).to eq rank
      end

      it "has the correct suit" do
        expect(card.suit).to eq suit
      end
    end

    context "with an invalid rank" do
      let(:rank) { 99 }

      it "raises an exception" do
        expect { card }.to raise_error Switch::Card::InvalidRankError
      end
    end

    context "with an invalid suit" do
      let(:suit) { "Lemons" }

      it "raises an exception" do
        expect { card }.to raise_error Switch::Card::InvalidSuitError
      end
    end
  end

  describe ".random" do
    it "selects a random card" do
      expect(described_class.random).to be_a described_class
    end
  end

  describe "#to_s" do
    let(:card) { described_class.new("Ace", "Spades") }

    it "returns the correct card value" do
      expect(card.to_s).to eq "Ace of Spades"
    end
  end

  describe "#symbol" do
    let(:card) { described_class.new("Ace", "Spades") }

    it "returns the correct card symbol" do
      expect(card.symbol).to eq "♠"
    end
  end

  describe "#ident" do
    let(:card) { described_class.new(rank, "Spades") }

    context "with a card with a numeric rank" do
      let(:rank) { 2 }

      it "returns the correct card ident" do
        expect(card.ident).to eq "2♠"
      end
    end

    context "with a picture card" do
      let(:rank) { "King" }

      it "returns the correct card ident" do
        expect(card.ident).to eq "K♠"
      end
    end
  end

  describe "#<=>" do
    let(:card1) { described_class.new(rank1, suit1) }
    let(:card2) { described_class.new(rank2, suit2) }
    let(:rank1) { 5 }
    let(:suit1) { "Spades" }
    let(:rank2) { 5 }
    let(:suit2) { "Spades" }

    context "with two cards of the same rank and suit" do
      it "treats the two cards as identical" do
        expect(card1 <=> card2).to eq 0
      end
    end

    context "with two cards of different rank but the same suit" do
      let(:rank2) { "King" }

      it "treats a lower rank as less than a higher one" do
        expect(card1 <=> card2).to eq (-1)
      end

      it "treats a higher rank as greater than a lower one" do
        expect(card2 <=> card1).to eq 1
      end
    end

    context "with two cards of the same rank but different suits" do
      let(:suit1) { "Hearts" }

      it "treats a lexographically lower suit as less than a higher one" do
        expect(card1 <=> card2).to eq (-1)
      end

      it "treats a lexographically higher rank as greater than a lower one" do
        expect(card2 <=> card1).to eq 1
      end
    end

    context "comparing against something other than a Card instance" do
      it "can't compare the two instances" do
        expect(card1 <=> []).to be_nil
      end
    end

    context "comparing with an ace" do
      let(:rank1) { "Ace" }

      it "treats the ace as high" do
        expect(card1 <=> card2).to eq 1
      end
    end

    context "comparing cards of the same suit" do
      let(:cards) { Switch::Card::SUITS.map { |s| Switch::Card.new(2, s) } }

      it "sorts them by lexographic ordering of suit name" do
        actual = cards.sort.map { |c| c.suit }
        expected = %w{ Clubs Diamonds Hearts Spades }.sort
        expect(actual).to eq expected
      end
    end
  end

  describe "#==" do
    let(:card1) { described_class.new("Ace", "Spades") }

    context "with matching cards" do
      let(:card2) { described_class.new("Ace", "Spades") }

      it "treats them as equal" do
        expect(card1 == card2).to be true
      end
    end

    context "with non-matching cards" do
      let(:card2) { described_class.new(2, "Hearts") }

      it "treats them as unequal" do
        expect(card1 == card2).to be false
      end
    end

    context "when comparing against something other than a Card instance" do
      it "treats them as unequal" do
        expect(card1 == []).to be false
      end
    end
  end
end
