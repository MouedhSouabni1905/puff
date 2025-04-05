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
  @current_nodes;
}

# Subroutine for iterating each line of the tree from the bottom up starting from the weights
# Returns the last two trees, which will be put in the second branch of the root of the tree
# !!! Make sure input is a reference !!!
sub iterate_tree {
  my $input_ref = shift;
  my @new_arr = create_nodes_array($input_ref);
  if ( $new_arr == 2 ) {
    @new_arr;
  } else {
    iterate_tree(\@new_arr);
  }
}

sub element_in_arr {
  my $el = shift;
  my @arr = shift;
  my $i = 0;
  my $found = 0;
  while ( $i<$arr ) {
    if ( $el == $arr[$i] ) {
      $found = 1;
      break;
    }
    $i++;
  }
  $found;
}

# Prints the tree
# The input is the node of the 2nd branch
@visited_nodes;
@parent_nodes;
# To add next time: add current node to parent nodes at each call,
# if the node was visited from backtracking (from the left child),
# then add it to visited_nodes and remove it from parent_nodes
# then pproceed to right_child
# If current node is in visited nodes, then go to parent node
sub print_tree {
  my $input_node_ref = shift;
  my %current_node = %$input_node_ref;
  my $children_ref = $current_node{'children'};
  my @children = %$children_ref;
  my $left_child = @children[0];
  my $right_child = @children[1];
  if ( element_in_arr($input_node_ref,visited_nodes) ) {
      print_tree(pop(@parent_nodes));
  } elsif ( element_in_arr(\$left_child,@visited_nodes)==1 ) {
      push(\%current_node,@visited_nodes);
      print_tree($right_child);
  } elsif ( ref($left_child) == 'SCALAR' ) {
      print "$$left_child\t$$right_child\t\t";
  } else {
      print_tree($left_child);
  }
  push($input_node_ref,@parent_nodes);
}

sub main {
  %initial=rd_weights('test.txt');
  @second=iterate_tree(\%initial);
  %root{'children'}=\@second;
  print_tree(\%root);
}

main();

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
