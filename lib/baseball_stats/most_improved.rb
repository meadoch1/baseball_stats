module Baseball
  module Questions
    class MostImproved
      attr_accessor :baseline_year, :observation_year, :floor, :answer
      def initialize(options={})
        @baseline_year = options.fetch(:baseline_year, 2009)
        @observation_year = options.fetch(:observation_year, 2010)
        @year_array = [@observation_year, @baseline_year]
        @floor = options.fetch(:floor, 200)
        @answer = []
        @answer_delta = nil
      end

      def sample(player)
        return if guards_are_violated? player

        delta = batting_average_improvement(player)
        comparison = (delta <=> @answer_delta) || 1
        case comparison
        when 0
          @answer << player
        when 1
          @answer = [player]
          @answer_delta = delta
        end
        comparison != -1
      end

      def format_answer(io)
        multiple_players = @answer.count > 1
        write_line io, "The player#{multiple_players ? 's' : ''} with the largest improvement #{@answer_delta ? 'of ' + @answer_delta.round(4).to_s : ''} in batting average between the years of #{baseline_year} and #{observation_year} #{multiple_players ? 'are' : 'is' }:"
        @answer.each do |player|
          write_line io, "    #{player.name} (#{player.id})"
        end
        write_line io, ''
      end

      protected
      def write_line(io, message)
        io.write "#{message}\n"
      end

      def guards_are_violated?(player)
        @answer.include?(player) || !player_has_stats( player) || !player_meets_floor( player)
      end

      def player_has_stats(player)
        @year_array.map {|year| player.has_batting_year?(year) }.inject {|result, value| result && value }
      end

      def player_meets_floor(player)
        @year_array.map {|year| player.at_bats(year) >= @floor }.inject { |result, value| result && value  }
      end

      def batting_average_improvement(player)
        @year_array.map { |year| player.batting_average(year)}.inject { |result, value| result - value  }
      end

    end
  end
end
