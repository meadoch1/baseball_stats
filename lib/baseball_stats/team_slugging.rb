module Baseball
  module Questions
    class TeamSlugging
      attr_accessor :year, :team_id
      def initialize(options={})
        @year = options.fetch :year, 2007
        @team_id = options.fetch :team_id, 'OAK'
        @answer = []
      end

      def sample(player)
        return unless player.team_id(@year) && player.team_id(@year).include?(@team_id)
        @answer << player
      end

      def format_answer(io)
        write_line io, "The slugging percentage for players on #{@team_id} in #{year} were:"
        @answer.sort! {|a, b| a.id <=> b.id }
        @answer.each do |player|
          pct = player.slugging_percentage(@year)
          pct = pct ? pct.round(4).to_s : 'n/a'
          write_line io, "    #{pct.ljust 6} - #{player.name} (#{player.id})"
        end
        write_line io, ''
      end

      protected
      def write_line(io, message)
        io.write "#{message}\n"
      end
    end
  end
end
