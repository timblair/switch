require_relative "../../spec_helper"

describe Switch::Deck do
  let(:deck) { described_class.new }

  describe ".build" do
    context "given no specific cards" do
      it "creates a deck with all available cards" do
        expect(described_class.build.size).to eq 52
      end
    end

    context "given specfic cards" do
      it "creates a deck with just the given cards" do
        cards = 5.times.map { Switch::Card.random }
        expect(described_class.build(cards).size).to eq 5
      end
    end

    context "given two full decks" do
      it "creates a double deck" do
        cards = Switch::Deck::ALL_CARDS + Switch::Deck::ALL_CARDS
        expect(described_class.build(cards).size).to eq 104
      end
    end
  end

  describe "#initialize" do
    it "creates an empty deck" do
      expect(deck).to be_empty
    end
  end

  describe "#<<" do
    context "with a single valid card" do
      let(:card) { Switch::Card.random }
      before(:each) { deck << card }

      it "makes the deck no longer empty" do
        expect(deck).not_to be_empty
      end

      it "increases the size of the deck" do
        expect(deck.size).to eq 1
      end

      it "appends a card to the end of the deck" do
        expect(deck.last).to eq card
      end
    end

    context "with a single non-card" do
      it "raises throws an exception" do
        expect { deck << {} }.to raise_error Switch::Deck::InvalidCardError
      end
    end

    context "with multiple valid cards" do
      let(:cards) { 5.times.map { Switch::Card.random } }
      before(:each) { deck << cards }

      it "increases the size of the deck" do
        expect(deck.size).to eq 5
      end

      it "appends the cards in order" do
        expect(deck).to eq cards
      end
    end
  end

  describe "#===" do
    let(:cards) { 5.times.map { Switch::Card.random } }
    before(:each) { deck << cards }

    context "with two decks with the same cards" do
      let(:other_deck) { deck.dup }

      context "in the same order" do
        it "treats them as equal" do
          expect(deck === other_deck).to be true
        end
      end

      context "in a different order" do
        it "treats them as equal" do
          other_deck.rotate!
          expect(deck === other_deck).to be true
        end
      end
    end

    context "with two decks with the different cards" do
      it "treats them as unequal" do
        other_deck = deck.dup.tap { |d| d << Switch::Card.random }
        expect(deck === other_deck).to be false
      end
    end
  end

  describe "#draw" do
    context "with an empty deck" do
      it "returns nil" do
        expect(deck.draw).to be_nil
      end
    end

    context "with a non-empty deck" do
      before(:each) { deck << cards }

      context "with a single card" do
        let(:cards) { Switch::Card.random }

        it "draws the card" do
          expect(deck.draw).to eq cards
        end

        it "leaves the deck empty" do
          deck.draw
          expect(deck).to be_empty
        end
      end

      context "with a single card" do
        let(:cards) { 5.times.map { Switch::Card.random } }

        it "draws the first card" do
          expect(deck.draw).to eq cards.first
        end

        it "leaves the deck empty" do
          deck.draw
          expect(deck.size).to be (cards.size - 1)
        end
      end
    end
  end
end
