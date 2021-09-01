 #!/usr/bin/env perl
use strict;
use warnings;
use Getopt::Long;
use Cwd qw( abs_path );
use File::Basename qw( dirname );
use lib dirname(abs_path($0));
use TableFormatter;

my $sqlite_path = '/usr/local/opt/sqlite/bin/sqlite3';
my $tsv_file2load = 'example_file.tsv';
my $format = 'markdown';
my $html = TableFormatter::get_formatted_file( $sqlite_path,  $tsv_file2load, $format);
print "$html\n";

