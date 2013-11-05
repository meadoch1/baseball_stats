module Baseball
  class BattingStat
    attr_accessor :player_id, :year, :team_id, :at_bats, :hits, :doubles, :triples, :home_runs, :runs_batted_in, :stolen_bases, :caught_stealing, :player

    def self.from_csv(row)
      stat = BattingStat.new
      stat.player_id = row["playerID"]
      stat.year = row["yearID"]
      stat.team_id = [row["teamID"]]
      stat.at_bats = row['AB'].to_i
      stat.hits = row['H'].to_i
      stat.doubles = row['2B'].to_i
      stat.triples = row['3B'].to_i
      stat.home_runs = row['HR'].to_i
      stat.runs_batted_in = row['RBI'].to_i
      stat.stolen_bases = row['SB'].to_i
      stat.caught_stealing = row['CS'].to_i
      stat
    end

    def add_stat(stat)
      raise ArgumentError.new 'Can only add stats for the same player and year' unless stat.player_id == player_id && stat.year == year

      team_id << stat.team_id
      team_id.flatten!
      @at_bats += stat.at_bats
      @hits += stat.hits
      @doubles += stat.doubles
      @triples += stat.triples
      @home_runs += stat.home_runs
      @runs_batted_in += stat.runs_batted_in
      @stolen_bases += stat.stolen_bases
      @caught_stealing += stat.caught_stealing
    end

    def valid?
      valid_string?(player_id) &&
        is_number?(year) &&
        team_id.all? {|value| valid_string? value }
    end

    def batting_average
      if hits && at_bats && (at_bats != 0)
        hits/(1.0 * at_bats)
      else
        0
      end
    end

    def slugging_percentage
      ((hits - doubles - triples - home_runs) + (2 * doubles) + (3 * triples) + (4 * home_runs)) / (1.0 * at_bats) if at_bats && at_bats != 0
    end

    protected
    def valid_string?(value)
      !(value.nil? || value.empty?)
    end

    def is_number?(value)
      true if Float(value) rescue false
    end

  end
end
