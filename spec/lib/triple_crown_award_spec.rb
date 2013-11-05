require 'spec_helper'

module Baseball
  describe TripleCrownAward do
    def new_batting_stat(score)
      b = BattingStat.new
      b.hits = base_score
      b.at_bats = 600
      b.runs_batted_in = base_score
      b.home_runs = base_score
      b.player_id = Random.new.rand(1000)
      b
    end

    def new_player(stat)
      p = Player.new stat.player_id
      p.add_batting_stat stat
      p
    end

    def batting_average(score)
      (score / 600.0 *10000000).to_i
    end

    let(:base_score) { 200 }
    let(:low_score) { 100 }
    let(:high_score) {300 }
    let(:baseline_submission) { [batting_average(base_score), base_score, base_score] }
    let(:award) {TripleCrownAward.new}
    before :each do
      @baseline_stat =  new_batting_stat base_score
      @baseline_player = new_player @baseline_stat
    end

    describe '#get_submission_data' do
      it 'pulls the correct data from a BattingStat' do
        @baseline_stat.runs_batted_in = low_score
        @baseline_stat.home_runs = high_score
        expect(award.get_submission_data @baseline_stat).to eq([batting_average(base_score), high_score, low_score])
      end
    end
    describe '#submit' do
      context 'when the first player is submitted' do
        it 'returns true' do
          expect(award.submit @baseline_stat).to be_true
        end
        it 'becomes the leader' do
          award.submit @baseline_stat
          expect(award.lead_stat).to eq([@baseline_stat])
        end
        it 'adjusts the high scores' do
          award.submit @baseline_stat
          expect(award.lead_values).to eq(award.get_submission_data @baseline_stat)
        end
      end
      context 'when the player does have one new highest score' do
        before :each do
          @test_stat = new_batting_stat base_score
          @test_stat.home_runs = high_score
          @test_stat.runs_batted_in = low_score
          @test_player = new_player @test_stat
          award.submit @baseline_stat
          @result = award.submit @test_stat
        end
        it 'returns false' do
          expect(@result).to be_false
        end
        it 'clears the leader position' do
          expect(award.lead_stat).to eq([])
        end
        it 'adjusts the scores' do
          expect(award.lead_values).to eq([batting_average(200.0), 300, 200])
        end
      end
      context 'when the player does have two new highest scores' do
        before :each do
          @test_stat = new_batting_stat base_score
          @test_stat.home_runs = high_score
          @test_stat.hits = high_score
          @test_stat.runs_batted_in = low_score
          @test_player = new_player @test_stat
          award.submit @baseline_stat
          @result = award.submit @test_stat
        end
        it 'returns false' do
          expect(@result).to be_false
        end
        it 'clears the leader position' do
          expect(award.lead_stat).to eq([])
        end
        it 'adjusts the scores' do
          expect(award.lead_values).to eq([batting_average(300.0), 300, 200])
        end
      end
      context 'when the player does have all new highest scores' do
        before :each do
          @test_stat = new_batting_stat base_score
          @test_stat.home_runs = high_score
          @test_player = new_player @test_stat
          award.submit @baseline_stat
          @result = award.submit @test_stat
        end
        it 'returns true' do
          expect(@result).to be_true
        end
        it 'awards the leader position' do
          expect(award.lead_stat).to eq([@test_stat])
        end
        it 'adjusts the scores' do
          expect(award.lead_values).to eq([batting_average(200.0), 300, 200])
        end
      end
      context 'when the player ties have all new highest scores' do
        before :each do
          @test_stat = new_batting_stat base_score
          @test_player = new_player @test_stat
          award.submit @baseline_stat
          @result = award.submit @test_stat
        end
        it 'returns true' do
          expect(@result).to be_true
        end
        it 'awards the leader position to both' do
          expect(award.lead_stat).to eq([@baseline_stat, @test_stat])
        end
        it 'keeps the scores' do
          expect(award.lead_values).to eq([batting_average(200.0), 200, 200])
        end
      end
    end

  end
end
