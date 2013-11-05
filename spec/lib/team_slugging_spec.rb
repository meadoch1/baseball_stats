require 'spec_helper'
module Baseball
  module Questions
    describe TeamSlugging do
      describe '.initialize' do
        context 'with default options' do
          let(:question) { TeamSlugging.new }
          it "has the correct year" do
            expect(question.year).to be == 2007
          end
          it "has the correct team" do
            expect(question.team_id).to be == 'OAK'
          end
        end
        context 'with different options' do
          let(:options) { { year: 2000, team_id: 'CHI' } }
          let(:question) { TeamSlugging.new options }
          it "has the correct year" do
            expect(question.year).to be == options[:year]
          end
          it "has the correct team_id" do
            expect(question.team_id).to be == options[:team_id]
          end
        end
      end
      let(:player_id) {'abc'}
      let(:player) {Player.new player_id }
      let(:include_row) { {'playerID' => player_id, 'yearID' => 2007,
          'teamID' => 'OAK', 'G' => 152, 'AB' => 563, 'R' => 96,
          'H' => 150, '2B' => 29, '3B' => 3, 'HR' => 15, 'RBI' => 103,
          'SB' => 30, 'CS' => 8 } }
      let(:exclude_row) { {'playerID' => player_id, 'yearID' => 2007,
          'teamID' => 'NYC', 'G' => 152, 'AB' => 563, 'R' => 96,
          'H' => 165, '2B' => 29, '3B' => 3, 'HR' => 15, 'RBI' => 103,
          'SB' => 30, 'CS' => 8 } }
      let(:question) { TeamSlugging.new }
      describe '#sample' do
        it "returns non-nil if the player qualifies" do
          player.add_batting_stat(BattingStat.from_csv include_row)
          expect(question.sample player).to_not be_nil
        end
        it "returns nil if the player doesn't qualify" do
          player.add_batting_stat(BattingStat.from_csv exclude_row)
          expect(question.sample player).to be_nil
        end
      end
    end
  end
end
