# Define a tree data structure object with nodes wich correspond to a pair of one character and one weight
%tree_origin = ();

# Subroutine for reading in the file and determining the weights of each word and adding them to the tree structures
%char_weight = ();
sub rd_weights {
  open(FILE, '<', @_[0]) or die "Cannot open file $filename for reading: $!";
  # @_[0] is the first element in the list of arguments
  foreach $line ( <FILE> ) {
    my @chars = map { ord } split //, $line;
    foreach $char ( @chars ) {
      if (exists $char_weight{$char}) {
        $char_weight{$char}++;
        next;
      }
      $char_weight{$char}=1;
    }
  }

}

rd_weights('LICENSE');

# Test -----------------------------------
#@weights = values %char_weight;
#@chars = keys %char_weight;
#$i=0;
#$size=@chars;
#while ($i<$size) {
#  print "$chars[$i] => $weights[$i]\n";
#  $i++;
#}
# ----------------------------------------

# Subroutine defined for the tree object that brings the nodes together to create de encoding tree
# Subroutine for decompressing, parses the header to decode the file
# Add a custom pseudo-EOF signature 8 bits that won't be used in the encoding
# Put the tree data structure in format as a header
# Subroutine that reads the tree structure as reference and translates the characters from the original file to bits in the target print
# Options:
# - Specify a source dir from which to read and compress files
# - If no target dir name specified, use the source dir name, otherwise the specified name
# - Same process for file decompression
# - -c option to compress and -d to decompress
# Subroutine that parses the arguments and prints usage and options if necessary
