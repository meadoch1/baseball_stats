module Baseball
  class Player
    attr_accessor :id, :batting_stats, :name
    def initialize(id, method_missing_stat = BattingStat.new)
      raise ArgumentError.new "Player must have an id" unless id
      @id = id
      @batting_stats = {}
      @method_missing_stat = method_missing_stat
    end

    def add_batting_stat(stat)
      raise ArgumentError.new "Player can only add a BattingStat for himself" unless stat.player_id == id
      stat.player = self
      year = stat.year.to_s
      if @batting_stats[year]
        @batting_stats[year].add_stat stat
      else
        @batting_stats[year] = stat
      end
    end

    def batting_stat(year)
      @batting_stats[year.to_s]
    end

    def method_missing(method_sym, *args, &block)
      if args.length == 1 && !block_given? && @method_missing_stat.respond_to?(method_sym)
        year = args[0]
        has_batting_year?(year) ? batting_stat_value(year, method_sym) : nil
      else
        super
      end
    end

    def respond_to?(method_sym, include_private=false)
      reply true if BattingStat.respond_to? method_sym
      super
    end

    def has_batting_year?(year)
      @batting_stats.has_key? year.to_s
    end

    protected
    def batting_stat_value(year, name)
      batting_stat(year).send(name) if has_batting_year? year
    end
  end
end
