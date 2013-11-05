require 'spec_helper'
module Baseball
  describe Player do
    describe '.initialize' do
      it "requires that an id be supplied" do
        expect{Player.new nil}.to raise_error
      end

      it "stores the id supplied" do
        Player.new('abc').id.should be == 'abc'
      end
    end

    let(:invalid_year) {'1900'}
    let(:player_id) {'abc'}
    let(:at_bats) {55}
    let(:test_stat) {BattingStat.new}
    let(:player) {Player.new player_id, test_stat }
    let(:year) {2012}
    let(:row) { {'playerID' => player_id, 'yearID' => year, 'teamID' => 'NYA', 'G' => 34,
        'AB' => at_bats, 'R' => 10, 'H' => 17, '2B' => 5, '3B' => 0, 'HR' => 2, 'RBI' => 5,
        'SB' => 5, 'CS' => 2 } }
    let(:stat) { BattingStat.from_csv row }
    before :each do
      player.add_batting_stat stat
    end

    describe "#add_batting_stat" do
      it "accepts a stat for himself" do
        expect(player.batting_stats.count).to be == 1
      end
      it "raises an error when a stat is assigned from someone else" do
        stat.player_id = 'bbb'
        expect{player.add_batting_stat(stat)}.to raise_error
      end
      it 'adds self as the stat.player' do
        expect(stat.player).to eq(player)
      end
      context 'with multiple stats in a single year' do
        before :each do
          new_row = row.dup
          new_row['teamID'] = 'CHI'
          @new_spec =  BattingStat.from_csv(new_row)
          player.add_batting_stat @new_spec
        end
        it 'adds the stats together if one already exists for that year' do
          expect(player.at_bats stat.year).to eq(2 * row['AB'])
        end
        it 'has both teams' do
          expect(player.team_id stat.year).to eq(['NYA','CHI'])
        end
      end
    end

    describe '#has_batting_year?' do
      it 'returns true if a the player has a batting_year added for that year' do
        expect(player.has_batting_year? stat.year).to be_true
      end
      it 'returns false if a the player does not have a batting_year added for that year' do
        expect(player.has_batting_year? invalid_year).to be_false
      end
    end

    describe "#method_missing" do
      context 'with a call to propagate to BattingStats' do
        let(:test_sym) { :at_bats }
        before :each do
          expect(test_stat).to receive(:respond_to?).with(test_sym).and_return(true)
        end
        it 'delegates calls to the appropriate BattingStat' do
          expect(player.batting_stats[year.to_s]).to receive(test_sym)
          player.method_missing test_sym, year
        end
        it 'returns the nil for an invalid year' do
          expect(player.method_missing test_sym, invalid_year).to be_nil
        end
      end
      context "with a call that doesn't match a BattingStat method" do
        it 'raises an error' do
          expect {player.method_missing :foo, year}.to raise_error
          expect {player.method_missing :at_bats, year, year}.to raise_error
          expect {player.method_missing :at_bats, year, lambda {puts 'no' } }.to raise_error
        end
      end
    end
  end
end
