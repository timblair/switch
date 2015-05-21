require_relative "../../spec_helper"

describe Switch::Hand do
  let(:hand) { described_class.new }

  describe "#initialize" do
    it "is equivalent to a deck" do
      expect(hand).to be_a Switch::Deck
    end
  end

  describe "#draw" do
    context "from an empty deck" do
      let(:deck) { Switch::Deck.new }

      it "adds no cards to the hand" do
        hand.draw(deck)
        expect(hand).to be_empty
      end

      it "returns an empty hand" do
        expect(hand.draw(deck)).to be_empty
      end
    end

    context "from a non-empty deck" do
      let(:cards) { 5.times.map { Switch::Card.random } }
      let(:deck) { Switch::Deck.build(cards) }

      context "when drawing a single card" do
        it "draws the first card" do
          expect(hand.draw(deck)).to include cards.first
        end

        it "adds the card to the hand" do
          hand.draw(deck)
          expect(hand).to include cards.first
        end

        it "returns a hand containing the drawn card" do
          expect(hand.draw(deck) === [cards[0]]).to be true
        end

        it "removes the card from the deck" do
          hand.draw(deck)
          expect(deck).not_to include cards.first
        end
      end

      context "when drawing multiple cards" do
        context "when the deck has enough cards" do
          let(:count) { 3 }

          it "draws the right number of cards" do
            expect(hand.draw(deck, count).size).to eq count
          end

          it "adds all cards to the hand" do
            hand.draw(deck, count)
            expect(hand).to include(*cards[0...count])
          end

          it "returns a hand containing all drawn cards" do
            expect(hand.draw(deck, count) === cards[0...count]).to be true
          end

          it "removes all cards from the deck" do
            hand.draw(deck, count)
            expect(deck).not_to include(*cards[0...count])
          end
        end

        context "when the deck doesn't have enough cards" do
          let(:count) { 10 }

          it "draws as many cards as possible" do
            expect(hand.draw(deck, count).size).to eq cards.size
          end

          it "adds all cards to the hand" do
            hand.draw(deck, count)
            expect(hand).to include(*cards)
          end

          it "returns a hand containing just the drawn cards" do
            expect(hand.draw(deck, count) === cards).to be true
          end

          it "removes all cards from the deck" do
            hand.draw(deck, count)
            expect(deck).not_to include(*cards)
          end
        end
      end
    end
  end
end
