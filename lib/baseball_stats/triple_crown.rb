module Baseball
  module Questions
    class TripleCrown
      attr_reader :year, :award
      def initialize(options={})
        @year = options.fetch :year, 2011
        @award = options.fetch :award, TripleCrownAward.new
      end

      def sample(player)
        return unless player.has_batting_year? @year
        stat = player.batting_stat @year
        return if @award.lead_stat.include? stat
        @award.submit stat
      end

      def format_answer(io)
        write_line io, "Triple Crown for #{@year}: "
        if @award.lead_stat.empty?
          write_line io, "  (No winner)"
        else
          @award.lead_stat.each do |stat|
            write_line io, "    #{stat.player.name} (#{stat.player.id})"
          end
          write_line io, ''
        end
      end

      protected
      def write_line(io, message)
        io.write "#{message}\n"
      end

    end
  end
end
