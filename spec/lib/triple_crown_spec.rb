require 'spec_helper'
module Baseball
  module Questions
    describe TripleCrown do
      describe '.initialize' do
        context 'with default options' do
          let(:question) { TripleCrown.new }
          it "has the correct year" do
            expect(question.year).to be == 2011
          end
          it "has a non-null award" do
            expect(question.award).to_not be_nil
          end
        end
        context 'with different options' do
          let(:options) { { year: 2000, award: TripleCrownAward.new } }
          let(:question) { TripleCrown.new options }
          it "has the correct year" do
            expect(question.year).to be == options[:year]
          end
          it "has the correct award" do
            expect(question.award).to be == options[:award]
          end
        end
      end
      describe '#sample' do
        let(:award) { TripleCrownAward.new }
        let(:options) { { year: 2000, award: award } }
        let(:question) { TripleCrown.new options }
        let(:player) { double(Player) }
        let(:stat) {double(BattingStat) }
        it 'returns if the player does not have a stat for the year' do
          expect(player).to receive(:has_batting_year?).with(options[:year]).and_return(false)
          expect(player).to_not receive(:batting_stat)
          expect(award).to_not receive(:lead_stat)
          expect(award).to_not receive(:submit)
          question.sample(player)
        end
        it 'returns if the award already has the stat as a lead' do
          expect(player).to receive(:has_batting_year?).with(options[:year]).and_return(true)
          expect(player).to receive(:batting_stat).with(options[:year]).and_return(stat)
          expect(award).to receive(:lead_stat).and_return([stat])
          expect(award).to_not receive(:submit)
          question.sample(player)
        end
        it "submits the player's stat to the award if no returns" do
          expect(player).to receive(:has_batting_year?).with(options[:year]).and_return(true)
          expect(player).to receive(:batting_stat).with(options[:year]).and_return(stat)
          expect(award).to receive(:lead_stat).and_return([])
          expect(award).to receive(:submit).with(stat)
          question.sample(player)
        end
      end
    end
  end
end
