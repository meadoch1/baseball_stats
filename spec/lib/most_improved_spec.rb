require 'spec_helper'
module Baseball
  module Questions
    describe MostImproved do
      describe '.initialize' do
        context 'with default options' do
          let(:question) { MostImproved.new }
          it "has the correct baseline year" do
            expect(question.baseline_year).to be == 2009
          end
          it "has the correct observation year" do
            expect(question.observation_year).to be == 2010
          end
          it "has the correct floor" do
            expect(question.floor).to be == 200
          end
        end
        context 'with different options' do
          let(:options) { { baseline_year: 2000, observation_year: 2002, floor: 100 } }
          let(:question) { MostImproved.new options }
          it "has the correct baseline year" do
            expect(question.baseline_year).to be == options[:baseline_year]
          end
          it "has the correct observation year" do
            expect(question.observation_year).to be == options[:observation_year]
          end
          it "has the correct floor" do
            expect(question.floor).to be == options[:floor]
          end
        end
      end
      let(:player_id) {'abc'}
      let(:player) {Player.new player_id }
      let(:baseline_row) { {'playerID' => player_id, 'yearID' => 2009,
          'teamID' => 'NYA', 'G' => 152, 'AB' => 563, 'R' => 96,
          'H' => 150, '2B' => 29, '3B' => 3, 'HR' => 15, 'RBI' => 103,
          'SB' => 30, 'CS' => 8 } }
      let(:observation_row) { {'playerID' => player_id, 'yearID' => 2010,
          'teamID' => 'NYA', 'G' => 152, 'AB' => 563, 'R' => 96,
          'H' => 165, '2B' => 29, '3B' => 3, 'HR' => 15, 'RBI' => 103,
          'SB' => 30, 'CS' => 8 } }
      let(:question) { MostImproved.new }
      describe '#sample' do
        it "returns true if the player qualifies" do
          player.add_batting_stat(BattingStat.from_csv baseline_row)
          player.add_batting_stat(BattingStat.from_csv observation_row)
          expect(question.sample player).to be_true
        end
        context "with missing yearly stats" do
          it "returns nil if the player has no stats" do
            expect(question.sample player).to be_nil
          end
          it "returns nil if the player has only the baseline year" do
            player.add_batting_stat(BattingStat.from_csv baseline_row)
            expect(question.sample player).to be_nil
          end
          it "returns nil if the player has only the observation year" do
            player.add_batting_stat(BattingStat.from_csv observation_row)
            expect(question.sample player).to be_nil
          end
        end
        context "with low yearly at bats" do
          it "returns nil if the baseline year at_bats is low" do
            baseline_row['AB'] = 150
            player.add_batting_stat(BattingStat.from_csv baseline_row)
            player.add_batting_stat(BattingStat.from_csv observation_row)
            expect(question.sample player).to be_nil
          end
          it "returns nil if the player has only the observation year" do
            observation_row['AB'] = 150
            player.add_batting_stat(BattingStat.from_csv baseline_row)
            player.add_batting_stat(BattingStat.from_csv observation_row)
            expect(question.sample player).to be_nil
          end
        end
      end

      context "checking comparison against existing players" do
        let(:comparison_player) {Player.new "#{player_id}"}
        let(:io) {StringIO.new}
        before :each do
          player.add_batting_stat(BattingStat.from_csv baseline_row)
          player.add_batting_stat(BattingStat.from_csv observation_row)
          question.sample player
        end
        context 'when a player has the best improvement' do
          before :each do
            baseline_row['H'] = 0
            comparison_player.add_batting_stat(BattingStat.from_csv baseline_row)
            comparison_player.add_batting_stat(BattingStat.from_csv observation_row)
          end
          describe '#sample' do
            it 'returns true' do
              expect(question.sample comparison_player).to be_true
            end
            it 'sets the player to the only entry in the answer array' do
              question.sample comparison_player
              expect(question.answer).to eq([comparison_player])
            end
          end
          describe '#formatted_answer' do
            before :each do
              question.format_answer io
            end
            it 'phrases output for a single player' do
              expect(io.string).to be =~ /player with/
              expect(io.string).to be =~ /is:/
            end
            it 'includes the player_id' do
              expect(io.string).to be =~ /(#{player.id})/
            end
          end
        end
        context 'when a player ties the best improvement' do
          before :each do
            comparison_player.add_batting_stat(BattingStat.from_csv baseline_row)
            comparison_player.add_batting_stat(BattingStat.from_csv observation_row)
            comparison_player.id = 'def'
          end
          describe '#sample' do
            it 'returns true' do
              expect(question.sample comparison_player).to be_true
            end
            it 'adds the player to the answer array' do
              question.sample comparison_player
              expect(question.answer).to include(comparison_player)
              expect(question.answer).to include(player)
            end
          end
          describe '#formatted_answer' do
            before :each do
              question.sample comparison_player
              question.format_answer io
            end
            it 'phrases output for multiple players' do
              expect(io.string).to be =~ /players with/
              expect(io.string).to be =~ /are:/
            end
            it 'includes the player_ids' do
              expect(io.string).to be =~ /(#{player.id})/
              expect(io.string).to be =~ /(#{comparison_player.id})/
            end
          end
        end
        describe '#sample' do
          context 'when a player is below the best improvement' do
            before :each do
              observation_row['H'] = 0
              comparison_player.add_batting_stat(BattingStat.from_csv baseline_row)
              comparison_player.add_batting_stat(BattingStat.from_csv observation_row)
            end
            it 'returns true' do
              expect(question.sample comparison_player).to be_false
            end
            it 'adds the player to the answer array' do
              question.sample comparison_player
              expect(question.answer).to eq([player])
            end
          end
          context 'when a player is already in the most improved list' do
            it 'returns nil' do
              expect(question.sample player).to be_nil
            end
          end
        end
      end
    end
  end
end
