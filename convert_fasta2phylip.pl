use strict;
use warnings;
use Bio::AlignIO;

my $filename = $ARGV[0];

my $in = Bio::AlignIO->new(-file => "$filename" ,
                        -format => 'fasta');

my $out = Bio::AlignIO->new(-file => ">$filename.phylip",
                         -format => 'phylip',
                         -idlength=>300 );

while ( my $aln = $in->next_aln ) {
    $out->write_aln($aln);
}
