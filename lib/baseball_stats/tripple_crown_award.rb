module Baseball
  class TripleCrownAward
    attr_accessor :lead_stat, :lead_values
    def initialize
      @lead_stat = []
    end

    def get_submission_data(stat)
      [(stat.batting_average * 10000000).to_i, stat.home_runs, stat.runs_batted_in]
    end

    def submit(stat)
      return false if stat.at_bats < 502 #MLB rules for winning a batting title
      submission = get_submission_data stat
      test_lead_values submission, stat
      !!test_lead_stat(submission, stat)
    end

    protected
    def test_lead_values(submission, stat)
      test = submission.dup
      test = @lead_values.each_with_index.map { |value, i| [value, test[i]].max} if @lead_values
      unless test == @lead_values
        reset_lead test
      end
    end

    def test_lead_stat(submission, stat)
      @lead_stat << stat if @lead_values == submission
    end

    def reset_lead(submission)
      @lead_values = submission
      @lead_stat = []
    end

  end
end
