require 'spec_helper'
module Baseball
  describe BattingStat do
    let(:row) { {'playerID' => 'abcd', 'yearID' => 2012, 'teamID' => 'NYA', 'G' => 34,
        'AB' => 55, 'R' => 10, 'H' => 17, '2B' => 5, '3B' => 0, 'HR' => 2, 'RBI' => 5,
        'SB' => 5, 'CS' => 2 } }
    let(:stat) { BattingStat.from_csv row }
    describe '.from_csv' do
      it "initializes values" do
        expect(stat.player_id).to eq(row['playerID'])
        expect(stat.year).to eq(row['yearID'])
        expect(stat.team_id).to eq([row['teamID']])
        expect(stat.at_bats).to eq(row['AB'])
        expect(stat.hits).to eq(row['H'])
        expect(stat.doubles).to eq(row['2B'])
        expect(stat.triples).to eq(row['3B'])
        expect(stat.home_runs).to eq(row['HR'])
        expect(stat.runs_batted_in).to eq(row['RBI'])
        expect(stat.stolen_bases).to eq(row['SB'])
        expect(stat.caught_stealing).to eq(row['CS'])
      end
    end

    describe '#add_stat' do
      let(:stat2) { s = BattingStat.from_csv row; s.team_id = 'CHI'; s}
      before :each do
        stat.add_stat(stat2)
      end
      it 'adds the team' do
        expect(stat.team_id).to eq(['NYA','CHI'])
      end
    end
    describe '#batting_average' do
      it 'returns the correct value' do
        expect(stat.batting_average).to be_within(0.0001).of(0.309)
      end
      it 'returns 0 when at_bats == 0' do
        stat.at_bats = 0
        expect(stat.batting_average).to eq(0)
      end
      it 'returns 0 when at_bats is nil' do
        stat.at_bats = nil
        expect(stat.batting_average).to eq(0)
      end
      it 'returns 0 when hits is nil' do
        stat.hits = nil
        expect(stat.batting_average).to eq(0)
      end
    end
    describe '#slugging_percentage' do
      it 'returns the correct value' do
        expect(stat.slugging_percentage).to be_within(0.0001).of(0.509)
      end
      it 'returns 0 when at_bats == 0' do
        stat.at_bats = 0
        expect(stat.batting_average).to eq(0)
      end
      it 'returns 0 when at_bats is nil' do
        stat.at_bats = nil
        expect(stat.batting_average).to eq(0)
      end
    end
    describe '#valid?' do
#      ['playerID', 'yearID', 'teamID', 'AB', 'H', '2B', '3B', 'HR', 'RBI','SB', 'CS'].each do |key|
      ['playerID', 'yearID', 'teamID'].each do |key|
        it "fails for blank #{key}" do
          row[key] = ''
          expect(BattingStat.from_csv(row).valid?).to be_false
        end
      end
      it 'returns true for a valid stat' do
        expect(BattingStat.from_csv(row).valid?).to be_true
      end
    end
  end
end
