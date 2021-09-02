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

=head
The HTML returned by "get_formatted_file()" is not formatted very nicely.
It is not a full HTML document and is not even enclosed in <table> tags. The tags themselves are in upper case (<TR>) which is very 1990s and the table rows are split into separate lines. See file "output_raw.html".

The following function takes this "raw" html" as input and creates a full HTML document with it as an embedded table. The splits in the table rows are removed and the tags are all in lower case.
=cut

sub get_formatted_html_page {
    my $raw_html = shift;
    my $page_title = shift;
    my $html_page_top = _get_html_page_top($page_title);
    my $html_page_bottom = _get_html_page_bottom();
    $raw_html =~ s/(<\/?)(T[RHD]>)/lc($1 . $2)/ge;
    $raw_html =~ s/(<\/t[hd]>)\n/$1/g;
    $raw_html =~ s/^/    /;
    my $formatted_html_page = $html_page_top . $raw_html . $html_page_bottom;
    return $formatted_html_page;

}

sub _get_html_page_top {
    my $page_title = shift;
    my $html_page_top = qq(<!DOCTYPE html>
<html lang="en">
<meta charset="UTF-8">
<title>$page_title</title>
<meta name="viewport" content="width=device-width,initial-scale=1">
<link rel="stylesheet" href="">
<style>
table, th, td {
  border: 1px solid black;
  border-collapse: collapse;
}
#generated_table {
  display: flex;
  justify-content: center;
}
.center {
  width: 800px;
}
</style>
<script src=""></script>
<body>
<div id="generated_table">
<table>);
    return $html_page_top;
}

sub _get_html_page_bottom {
    my $html_page_bottom = qq(
</div>
</table>
</body>
</html>
    );
}
1;


