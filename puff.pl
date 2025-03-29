# Subroutine for reading in the file and determining the weights of each word and adding them to the tree structures

sub rd_weights {
  my %char_weight;
  my $filename=shift;
  open(FILE, '<', $filename) or die "Cannot open file $filename for reading: $!";
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
  %char_weight;
}

# rd_weights('LICENSE');

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
  my @vals = shift;
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

# Subroutines that creates new nodes from previous nodes
# Calculates the sum of the weights of the two lowest-weighted
# nodes and adds them together into a new node and adds that
# node to an array of nodes which is returned by the funtion
# !!! Make sure the input argument is a reference !!!
sub create_nodes_array {
  $input_arg = shift;
  my @weights;
  my @elements;
  my @current_nodes;
  if (ref($input_arg) eq 'HASH') {
    @weights = values %$input_arg;
    @elements = keys %$input_arg;
  } elsif (ref($input_arg) eq 'ARRAY') {
    @input_arr = @$input_arg;
    $i=0;
    while ($i<$input_arr) {
      $curr_hashref = @input_arr[$i];
      %curr_hash = %$curr_hashref;
      push(@weights,$curr_hash{'weight'});
      $i++;
    }
    @elements = @input_arr;
  }
  while ( @elements != 0 ) {
    # Find the minimum and add it to @children
    my %current_node;
    my $curr_node_weight;
    my @children;
    my $min = min(@vals);
    push(@children,\$elements[$min]);
    $curr_node_weight+=$weights[$min];
    # Remove from @elements and @weights
    splice(@weights,$min,1);
    splice(@elements,$min,1);
    # Repeat for the 2nd minimum value
    push(@children,\$elements[$min]);
    $curr_node_weight+=$weights[$min];
    splice(@weights,$min,1);
    splice(@elements,$min,1);
    # Put them in the current node
    $current_node{'children'}=\@children;
    $current_node{'weight'}=$curr_node_weight;
    # Add it to the list of current nodes
    push(@current_nodes,\%current_node);
  }
  @current_node;
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
