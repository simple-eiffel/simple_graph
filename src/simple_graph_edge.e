note
	description: "Edge in a graph with target node and optional weight"
	author: "Larry Rix"
	date: "$Date$"
	revision: "$Revision$"

class
	SIMPLE_GRAPH_EDGE

inherit
	ANY
		redefine
			out
		end

create
	make,
	make_unweighted

feature {NONE} -- Initialization

	make (a_to: INTEGER; a_weight: REAL_64)
			-- Create edge to `a_to' with `a_weight'.
		require
			valid_to: a_to > 0
		do
			to_node := a_to
			weight := a_weight
		ensure
			to_set: to_node = a_to
			weight_set: weight = a_weight
		end

	make_unweighted (a_to: INTEGER)
			-- Create edge to `a_to' with default weight 1.0.
		require
			valid_to: a_to > 0
		do
			to_node := a_to
			weight := 1.0
		ensure
			to_set: to_node = a_to
			default_weight: weight = 1.0
		end

feature -- Access

	to_node: INTEGER
			-- Target node ID.

	weight: REAL_64
			-- Edge weight.

feature -- Comparison

	is_equal_edge (other: SIMPLE_GRAPH_EDGE): BOOLEAN
			-- Is this edge equal to `other'?
		do
			Result := to_node = other.to_node and weight = other.weight
		end

feature -- Output

	out: STRING
			-- String representation.
		do
			Result := "->" + to_node.out
			if weight /= 1.0 then
				Result.append (" (w=" + weight.out + ")")
			end
		end

invariant
	valid_to_node: to_node > 0

end
