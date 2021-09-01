package TableFormatter;
use strict;
use warnings;

=head
Utility functions that make use of the sqlite3 client to convert TSV files to different outputs (HTML, markdown and others)

Works as follows:

- Invokes the sqlite3 client
- Loads the file into an in memory database
- Sets the mode to the desired output
- Selects all the rows from the table
- Returns the formatted table output
- Since it uses an in-memory database, the database disappears when the calling script exits 
=cut

sub get_formatted_file {
    my $sqlite3_path = shift;
    my $tsv_file2load = shift;
    my $format = shift;
    my $cmd = qq($sqlite3_path :memory: ".mode tabs" ".import  $tsv_file2load tbl" ".headers on" ".mode $format" "SELECT * FROM tbl;");
    my $table_html = `$cmd`;
    return $table_html;
}

1;


