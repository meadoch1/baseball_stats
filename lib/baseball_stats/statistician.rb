require 'csv'

module Baseball
  class Statistician
    attr_accessor :batting_file_name, :master_file_name, :questions, :io_out
    def initialize(options={})
      @batting_file_name = options.fetch :batting_file, data_dir + '/Batting-07-12.csv'
      @master_file_name = options.fetch :master_file, data_dir + '/Master-small.csv'
      @questions = options.fetch :questions, [Questions::MostImproved.new, Questions::TeamSlugging]
      @io_out = options.fetch :io, STDOUT
    end

    def analyze(options={})
      verify_read_file @batting_file_name
      verify_read_file @master_file_name
      players = {}
      CSV.foreach(batting_file_name, headers: true) do |row|
        stat = BattingStat.from_csv row
        next unless stat.valid?
        update_player(players, stat)
      end
      players.each do |player_id, player|
        @questions.each { |question| question.sample player }
      end

      @questions.each do |question|
        question.format_answer @io_out
      end
    end

    def verify_read_file(filename)
      File.open filename
    end

    def update_player(players, stat)
      players[stat.player_id] = Player.new stat.player_id unless players[stat.player_id]
      player = players[stat.player_id]
      player.add_batting_stat stat
    end

    protected
    def data_dir
      File.expand_path(File.join(File.dirname(__FILE__), '..', '..','/data') )
    end
  end
end
