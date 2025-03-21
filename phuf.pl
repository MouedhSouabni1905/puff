# Define a tree data structure object with nodes wich correspond to a pair of one character and one weight
%root = {'first'=>'EOF'};
@tree_buffer = (\%root);

# Subroutine for reading in the file and determining the weights of each word and adding them to the tree structures
%char_weight;

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
sub min {
  my @vals = @_[0];
  my $m=0;
  my $i=0;
  foreach $x ( @vals ) {
    if ($x<$m) {
      $m=$i;
    }
    $i++;
  }
  $m;
}

sub create_binary_tree {
  my @vals = values %char_weight;
  my @ks = keys %char_weight;
  my %current_node;
  my %previous_node;
  my @children;
  $i=0;
  while ( $ks != 0 ) {
    # Find the minimum and add it to @children
    # Remove from @vals and @ks
    # Repeat for the 2nd minimum value
    # Put them together in the current node
    # If previous node is not empty, make it point to previous_node's (go back to check huffing algorithm)
    # Assign them to previous_node
  }

}
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
