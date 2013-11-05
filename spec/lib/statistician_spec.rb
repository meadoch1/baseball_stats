require 'spec_helper'

module Baseball
  describe Statistician do
    let(:data_dir) { File.expand_path(File.join(File.dirname(__FILE__), '..', '..', '/data/') ) }
    let(:batting_file) { data_dir + '/Batting-07-12.csv' }
    let(:master_file) { data_dir + '/Master-small.csv' }
    let(:most_improved) { Questions::MostImproved.new }
    let(:slugging) { Questions::TeamSlugging.new }
    let(:triple_crown_2011) { Questions::TripleCrown.new year: 2011 }
    let(:triple_crown_2012) { Questions::TripleCrown.new year: 2012 }
    let(:io) {StringIO.new}
    let(:questions) { [most_improved, slugging, triple_crown_2011, triple_crown_2012] }
    let(:options) { {batting_file: batting_file, master_file: master_file, questions: questions, io: io} }

    describe '.initialize' do
      let(:stat) {Statistician.new(options.merge(batting_file: 'foo', master_file: 'bar'))}
      it "utilizes the supplied batting file" do
        expect(stat.batting_file_name).to eq('foo')
      end
      it "utilizes the supplied master file" do
        expect(stat.master_file_name).to eq('bar')
      end
      it "utilizes the supplied questions" do
        expect(stat.questions).to eq(questions)
      end
      it "utilizes the supplied io" do
        expect(stat.io_out).to eq(io)
      end
    end

    let(:stat) {Statistician.new options}
    describe '#verify_read_file' do
      it 'raises and exception for an invalid file name' do
        expect {stat.verify_read_file 'foo'}.to raise_error
      end
      it 'returns a file object for a valid file name' do
        expect(stat.verify_read_file(data_dir).class).to eq(File)
      end
    end

    describe '#updated_player' do
      it 'implement this'
    end

    describe '#analyze' do
      it "produces output" do
        stat.analyze
        puts io.string
        expect(io.string.length).to be > 0
      end
    end
  end
end
