require "baseball_stats/version"

Dir["#{File.expand_path(File.dirname(__FILE__) + '/baseball_stats')}/*.rb"].each {|file| require file }
