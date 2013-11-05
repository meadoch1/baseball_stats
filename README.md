# BaseballStats


## Installation

Add this line to your application's Gemfile:

    gem 'baseball_stats'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install baseball_stats

## Usage

You can run the command line interface (CLI) for this application with the following command

    $ ./bin/baseball_stats analyze

It will perform the default analysis with the supplied data files.  If you wish to use different files you can supply them as arguments to the command.  To see instructions run

    $ ./bin/baseball_stats

The program is incomplete as of this date.  The following are yet to be addressed:

1. Fantasy scoring is yet to be implemented.
2. Testing of the output content and format is yet to be implemented.
3. Feature testing of the CLI is yet to be implemented.
4. Computation for the Triple Crown winner is incomplete.  A better understanding of the parameters for winning the Triple Crown is needed and possibly more data is required.
5. A review of the tests to ensure adequate coverage is pending.  Thus more tests might be merited.
6. A refactoring of the question objects to move responsibilities for formatting output is needed.
7. A command in the CLI to allow setting configuration parameters for the data files and the fantasy scoring values is needed.
8. Utilization of the Master file to have player's names to display is yet to be implemented.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
