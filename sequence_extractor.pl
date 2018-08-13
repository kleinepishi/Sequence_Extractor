=comment

Input needs to be $ perl sequence_extractor.pl -i in_file.gb -d sub_dir -o out_file.txt
It is also acceptable for the input file to be of .txt format
The order of -i, -o, -d doesn't matter, just be sure that the correct file is paired to it

=cut


#!/usr/bin/perl -w

use Getopt::Std;

%opt=();
getopts("i:d:o:",\%opt);

print "$opt{d}\t";
print "$opt{o}\t";
print "$opt{i}\n";

open (OUT, "+> $opt{o}") || die "Unable to open output file $opt{o}";
opendir(DIRECTORY, "./$opt{d}") || die  "Unable to open directory $opt{d}";

print OUT "Accession#\tLength\tGI\tOrganism\tLocus tag\tProduct\tProtein_ID\n";

%file = ();
$test_case = 0;
foreach my $file (readdir(DIRECTORY)) {
    if ($file eq $opt{i}) {
open (IN, "./$opt{d}/$file") || die "Unable to open input file $file";
for (<IN>) {
      chomp $_;
      if ($_ =~ /\=/){
      }
      elsif ($_ !~ /\"/) {
      }
      elsif ($test_case == 0){
      }
      else {
      s/^\s+// ;
      $f = (split /\"/)[0];
      $file{product} = "$file{product} $f";
      $test_case = 0;
      }
      if ($test_case == 1) {
  $test_case = 0;
      }
      if ((/bp/) && (/LOCUS/)) {
  ($First, $second) = (/(...\d+)\s+(\d+)/);
  $file{Accession} = ($First);
  $file{bp} = ($second);
      }
      elsif (/GeneID/) {
  my $Gene_ID = (split /\"/)[1];
  $file{Gene_ID} =(split /\:/, $Gene_ID)[1];
      }
      elsif (/ORGANISM/) {
  $file{Organism_ID} = substr($_, 10);
      }
      elsif (/POPTR_/ && (exists $file{Locus_Tag}) != 1) {
  my $POP_ID = (split/\(/)[1];
  $file{Locus_ID} = (split/\)/, $POP_ID)[0];
      }
      elsif (/product/) {
  @pro = split(/\"/, $_);
  $test_case = 1;
                  $file{product} = $pro[1];
      }
      elsif (/XP_/) {
  $file{Protein_ID} = (split /\"/)[1]; 
      }
      elsif (/^$/) {
  print OUT "$file{Accession}\t$file{bp}\t$file{Gene_ID}\t$file{Organism_ID}\t$file{Locus_ID}\t$file{product}\t$file{Protein_ID}\n";
  %file = ();
      }
}
close (IN);
    }
}

close (OUT);
closedir (DIRECTORY);

