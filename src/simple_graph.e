note
	description: "Generic graph data structure with adjacency list representation"
	author: "Larry Rix"
	date: "$Date$"
	revision: "$Revision$"

class
	SIMPLE_GRAPH [G -> ANY]

create
	make,
	make_directed

feature {NONE} -- Initialization

	make
			-- Create undirected graph.
		do
			is_directed := False
			create nodes.make (10)
			create adjacency.make (10)
			next_id := 1
		ensure
			not_directed: not is_directed
			empty: is_empty
		end

	make_directed
			-- Create directed graph.
		do
			is_directed := True
			create nodes.make (10)
			create adjacency.make (10)
			next_id := 1
		ensure
			directed: is_directed
			empty: is_empty
		end

feature -- Access

	is_directed: BOOLEAN
			-- Is this a directed graph?

	node_count: INTEGER
			-- Number of nodes in graph.
		do
			Result := nodes.count
		end

	edge_count: INTEGER
			-- Number of edges in graph.
		local
			l_count: INTEGER
			l_edges: detachable ARRAYED_LIST [SIMPLE_GRAPH_EDGE]
		do
			from adjacency.start
			until adjacency.after
			loop
				l_edges := adjacency.item_for_iteration
				if l_edges /= Void then
					l_count := l_count + l_edges.count
				end
				adjacency.forth
			end
			if is_directed then
				Result := l_count
			else
				Result := l_count // 2
			end
		end

	is_empty: BOOLEAN
			-- Is the graph empty?
		do
			Result := nodes.is_empty
		end

	has_node (a_id: INTEGER): BOOLEAN
			-- Does graph contain node with `a_id'?
		do
			Result := nodes.has (a_id)
		end

	has_edge (a_from, a_to: INTEGER): BOOLEAN
			-- Does graph contain edge from `a_from' to `a_to'?
		local
			l_edges: detachable ARRAYED_LIST [SIMPLE_GRAPH_EDGE]
			l_edge: SIMPLE_GRAPH_EDGE
		do
			if adjacency.has (a_from) then
				l_edges := adjacency.item (a_from)
				if l_edges /= Void then
					from l_edges.start
					until l_edges.after or Result
					loop
						l_edge := l_edges.item
						if l_edge.to_node = a_to then
							Result := True
						end
						l_edges.forth
					end
				end
			end
		end

	node (a_id: INTEGER): detachable G
			-- Data for node with `a_id'.
		require
			has_node: has_node (a_id)
		do
			Result := nodes.item (a_id)
		end

	neighbors (a_id: INTEGER): ARRAYED_LIST [INTEGER]
			-- List of neighbor node IDs for `a_id'.
		require
			has_node: has_node (a_id)
		local
			l_edges: detachable ARRAYED_LIST [SIMPLE_GRAPH_EDGE]
			l_edge: SIMPLE_GRAPH_EDGE
		do
			create Result.make (5)
			l_edges := adjacency.item (a_id)
			if l_edges /= Void then
				from l_edges.start
				until l_edges.after
				loop
					l_edge := l_edges.item
					Result.extend (l_edge.to_node)
					l_edges.forth
				end
			end
		end

	edge_weight (a_from, a_to: INTEGER): REAL_64
			-- Weight of edge from `a_from' to `a_to'.
		require
			has_edge: has_edge (a_from, a_to)
		local
			l_edges: detachable ARRAYED_LIST [SIMPLE_GRAPH_EDGE]
			l_edge: SIMPLE_GRAPH_EDGE
		do
			Result := 1.0
			l_edges := adjacency.item (a_from)
			if l_edges /= Void then
				from l_edges.start
				until l_edges.after
				loop
					l_edge := l_edges.item
					if l_edge.to_node = a_to then
						Result := l_edge.weight
					end
					l_edges.forth
				end
			end
		end

	all_nodes: ARRAYED_LIST [INTEGER]
			-- List of all node IDs.
		do
			create Result.make (node_count)
			from nodes.start
			until nodes.after
			loop
				Result.extend (nodes.key_for_iteration)
				nodes.forth
			end
		end

	all_edges: ARRAYED_LIST [TUPLE [from_node, to_node: INTEGER; weight: REAL_64]]
			-- List of all edges as tuples.
		local
			l_seen: HASH_TABLE [BOOLEAN, STRING]
			l_key: STRING
			l_edges: detachable ARRAYED_LIST [SIMPLE_GRAPH_EDGE]
			l_edge: SIMPLE_GRAPH_EDGE
			l_from: INTEGER
		do
			create Result.make (edge_count)
			create l_seen.make (edge_count)
			from adjacency.start
			until adjacency.after
			loop
				l_from := adjacency.key_for_iteration
				l_edges := adjacency.item_for_iteration
				if l_edges /= Void then
					from l_edges.start
					until l_edges.after
					loop
						l_edge := l_edges.item
						if is_directed then
							Result.extend ([l_from, l_edge.to_node, l_edge.weight])
						else
							-- For undirected, avoid duplicates
							l_key := l_from.min (l_edge.to_node).out + "-" + l_from.max (l_edge.to_node).out
							if not l_seen.has (l_key) then
								l_seen.put (True, l_key)
								Result.extend ([l_from, l_edge.to_node, l_edge.weight])
							end
						end
						l_edges.forth
					end
				end
				adjacency.forth
			end
		end

feature -- Element change

	add_node (a_data: G): INTEGER
			-- Add node with `a_data', return node ID.
		do
			Result := next_id
			nodes.put (a_data, Result)
			adjacency.put (create {ARRAYED_LIST [SIMPLE_GRAPH_EDGE]}.make (5), Result)
			next_id := next_id + 1
		ensure
			node_added: has_node (Result)
			count_increased: node_count = old node_count + 1
		end

	add_node_with_id (a_id: INTEGER; a_data: G)
			-- Add node with specific `a_id' and `a_data'.
		require
			id_positive: a_id > 0
			no_existing: not has_node (a_id)
		do
			nodes.put (a_data, a_id)
			adjacency.put (create {ARRAYED_LIST [SIMPLE_GRAPH_EDGE]}.make (5), a_id)
			if a_id >= next_id then
				next_id := a_id + 1
			end
		ensure
			node_added: has_node (a_id)
			count_increased: node_count = old node_count + 1
		end

	add_edge (a_from, a_to: INTEGER)
			-- Add edge from `a_from' to `a_to' with weight 1.0.
		require
			from_exists: has_node (a_from)
			to_exists: has_node (a_to)
		do
			add_edge_weighted (a_from, a_to, 1.0)
		ensure
			edge_exists: has_edge (a_from, a_to)
		end

	add_edge_weighted (a_from, a_to: INTEGER; a_weight: REAL_64)
			-- Add edge from `a_from' to `a_to' with `a_weight'.
		require
			from_exists: has_node (a_from)
			to_exists: has_node (a_to)
		local
			l_edge: SIMPLE_GRAPH_EDGE
			l_edges: detachable ARRAYED_LIST [SIMPLE_GRAPH_EDGE]
		do
			create l_edge.make (a_to, a_weight)
			l_edges := adjacency.item (a_from)
			if l_edges /= Void then
				l_edges.extend (l_edge)
			end
			if not is_directed and a_from /= a_to then
				create l_edge.make (a_from, a_weight)
				l_edges := adjacency.item (a_to)
				if l_edges /= Void then
					l_edges.extend (l_edge)
				end
			end
		ensure
			edge_exists: has_edge (a_from, a_to)
			reverse_for_undirected: not is_directed and a_from /= a_to implies has_edge (a_to, a_from)
		end

	remove_node (a_id: INTEGER)
			-- Remove node `a_id' and all its edges.
		require
			has_node: has_node (a_id)
		local
			l_edges: detachable ARRAYED_LIST [SIMPLE_GRAPH_EDGE]
		do
			-- Remove all edges to this node
			from adjacency.start
			until adjacency.after
			loop
				l_edges := adjacency.item_for_iteration
				if l_edges /= Void then
					from l_edges.start
					until l_edges.after
					loop
						if l_edges.item.to_node = a_id then
							l_edges.remove
						else
							l_edges.forth
						end
					end
				end
				adjacency.forth
			end
			-- Remove the node
			adjacency.remove (a_id)
			nodes.remove (a_id)
		ensure
			node_removed: not has_node (a_id)
			count_decreased: node_count = old node_count - 1
		end

	remove_edge (a_from, a_to: INTEGER)
			-- Remove edge from `a_from' to `a_to'.
		require
			has_edge: has_edge (a_from, a_to)
		local
			l_edges: detachable ARRAYED_LIST [SIMPLE_GRAPH_EDGE]
		do
			l_edges := adjacency.item (a_from)
			if l_edges /= Void then
				from l_edges.start
				until l_edges.after
				loop
					if l_edges.item.to_node = a_to then
						l_edges.remove
					else
						l_edges.forth
					end
				end
			end
			if not is_directed then
				l_edges := adjacency.item (a_to)
				if l_edges /= Void then
					from l_edges.start
					until l_edges.after
					loop
						if l_edges.item.to_node = a_from then
							l_edges.remove
						else
							l_edges.forth
						end
					end
				end
			end
		ensure
			edge_removed: not has_edge (a_from, a_to)
		end

	clear
			-- Remove all nodes and edges.
		do
			nodes.wipe_out
			adjacency.wipe_out
			next_id := 1
		ensure
			empty: is_empty
		end

feature -- Traversal

	bfs (a_start: INTEGER): ARRAYED_LIST [INTEGER]
			-- Breadth-first traversal starting from `a_start'.
		require
			has_node: has_node (a_start)
		local
			l_queue: ARRAYED_QUEUE [INTEGER]
			l_visited: HASH_TABLE [BOOLEAN, INTEGER]
			l_current: INTEGER
			l_neighbors: ARRAYED_LIST [INTEGER]
		do
			create Result.make (node_count)
			create l_queue.make (node_count)
			create l_visited.make (node_count)

			l_queue.put (a_start)
			l_visited.put (True, a_start)

			from
			until l_queue.is_empty
			loop
				l_current := l_queue.item
				l_queue.remove
				Result.extend (l_current)

				l_neighbors := neighbors (l_current)
				from l_neighbors.start
				until l_neighbors.after
				loop
					if not l_visited.has (l_neighbors.item) then
						l_visited.put (True, l_neighbors.item)
						l_queue.put (l_neighbors.item)
					end
					l_neighbors.forth
				end
			end
		ensure
			starts_with_start: not Result.is_empty implies Result.first = a_start
		end

	dfs (a_start: INTEGER): ARRAYED_LIST [INTEGER]
			-- Depth-first traversal starting from `a_start'.
		require
			has_node: has_node (a_start)
		local
			l_stack: ARRAYED_STACK [INTEGER]
			l_visited: HASH_TABLE [BOOLEAN, INTEGER]
			l_current: INTEGER
			l_neighbors: ARRAYED_LIST [INTEGER]
			i: INTEGER
		do
			create Result.make (node_count)
			create l_stack.make (node_count)
			create l_visited.make (node_count)

			l_stack.put (a_start)

			from
			until l_stack.is_empty
			loop
				l_current := l_stack.item
				l_stack.remove
				if not l_visited.has (l_current) then
					l_visited.put (True, l_current)
					Result.extend (l_current)

					l_neighbors := neighbors (l_current)
					from i := l_neighbors.count
					until i < 1
					loop
						if not l_visited.has (l_neighbors [i]) then
							l_stack.put (l_neighbors [i])
						end
						i := i - 1
					end
				end
			end
		ensure
			starts_with_start: not Result.is_empty implies Result.first = a_start
		end

feature -- Shortest Path

	dijkstra (a_start, a_end: INTEGER): ARRAYED_LIST [INTEGER]
			-- Shortest path from `a_start' to `a_end' using Dijkstra's algorithm.
			-- Returns empty list if no path exists.
		require
			start_exists: has_node (a_start)
			end_exists: has_node (a_end)
		local
			l_distances: HASH_TABLE [REAL_64, INTEGER]
			l_previous: HASH_TABLE [INTEGER, INTEGER]
			l_visited: HASH_TABLE [BOOLEAN, INTEGER]
			l_current, l_neighbor: INTEGER
			l_min_dist, l_alt, l_dist: REAL_64
			l_found: BOOLEAN
			l_neighbors, l_nodes: ARRAYED_LIST [INTEGER]
		do
			create Result.make (node_count)
			create l_distances.make (node_count)
			create l_previous.make (node_count)
			create l_visited.make (node_count)

			-- Initialize distances
			l_nodes := all_nodes
			from l_nodes.start
			until l_nodes.after
			loop
				l_distances.put ({REAL_64}.max_value, l_nodes.item)
				l_nodes.forth
			end
			l_distances.force (0.0, a_start)

			from
			until l_found
			loop
				-- Find unvisited node with minimum distance
				l_min_dist := {REAL_64}.max_value
				l_current := -1
				l_nodes := all_nodes
				from l_nodes.start
				until l_nodes.after
				loop
					if not l_visited.has (l_nodes.item) then
						if l_distances.has (l_nodes.item) then
							l_dist := l_distances.item (l_nodes.item)
							if l_dist < l_min_dist then
								l_min_dist := l_dist
								l_current := l_nodes.item
							end
						end
					end
					l_nodes.forth
				end

				if l_current = -1 then
					-- No more reachable nodes
					l_found := True
				elseif l_current = a_end then
					l_found := True
				elseif l_min_dist >= {REAL_64}.max_value then
					-- No path exists
					l_found := True
					l_current := -1  -- Signal no path
				else
					l_visited.put (True, l_current)
					l_neighbors := neighbors (l_current)
					from l_neighbors.start
					until l_neighbors.after
					loop
						l_neighbor := l_neighbors.item
						if not l_visited.has (l_neighbor) then
							l_alt := l_min_dist + edge_weight (l_current, l_neighbor)
							if l_distances.has (l_neighbor) then
								l_dist := l_distances.item (l_neighbor)
								if l_alt < l_dist then
									l_distances.force (l_alt, l_neighbor)
									l_previous.force (l_current, l_neighbor)
								end
							end
						end
						l_neighbors.forth
					end
				end
			end

			-- Reconstruct path if destination was reached
			if l_current = a_end then
				l_current := a_end
				from
				until l_current = a_start
				loop
					Result.put_front (l_current)
					if l_previous.has (l_current) then
						l_current := l_previous.item (l_current)
					else
						-- No path found (shouldn't happen if we got here)
						Result.wipe_out
						l_current := a_start
					end
				end
				if not Result.is_empty then
					Result.put_front (a_start)
				end
			end
		ensure
			empty_or_starts_at_start: Result.is_empty or else Result.first = a_start
			empty_or_ends_at_end: Result.is_empty or else Result.last = a_end
		end

	shortest_distance (a_start, a_end: INTEGER): REAL_64
			-- Shortest distance from `a_start' to `a_end'.
			-- Returns -1 if no path exists.
		require
			start_exists: has_node (a_start)
			end_exists: has_node (a_end)
		local
			l_path: ARRAYED_LIST [INTEGER]
			i: INTEGER
		do
			l_path := dijkstra (a_start, a_end)
			if l_path.is_empty then
				Result := -1.0
			else
				Result := 0.0
				from i := 1
				until i >= l_path.count
				loop
					Result := Result + edge_weight (l_path [i], l_path [i + 1])
					i := i + 1
				end
			end
		end

feature -- Analysis

	is_connected: BOOLEAN
			-- Is the graph connected? (all nodes reachable from any node)
		local
			l_traversal: ARRAYED_LIST [INTEGER]
			l_nodes: ARRAYED_LIST [INTEGER]
		do
			if is_empty then
				Result := True
			else
				l_nodes := all_nodes
				l_traversal := bfs (l_nodes.first)
				Result := l_traversal.count = node_count
			end
		end

	has_cycle: BOOLEAN
			-- Does the graph contain a cycle?
		local
			l_visited: HASH_TABLE [INTEGER, INTEGER]  -- 0=white, 1=gray, 2=black
			l_found: BOOLEAN
			l_nodes: ARRAYED_LIST [INTEGER]
		do
			create l_visited.make (node_count)
			l_nodes := all_nodes
			from l_nodes.start
			until l_nodes.after
			loop
				l_visited.put (0, l_nodes.item)
				l_nodes.forth
			end
			l_nodes := all_nodes
			from l_nodes.start
			until l_nodes.after or l_found
			loop
				if l_visited.item (l_nodes.item) = 0 then
					l_found := has_cycle_dfs (l_nodes.item, l_visited, -1)
				end
				l_nodes.forth
			end
			Result := l_found
		end

	topological_sort: ARRAYED_LIST [INTEGER]
			-- Topological ordering of nodes (directed acyclic graph only).
			-- Returns empty list if graph has a cycle.
		require
			directed: is_directed
		local
			l_in_degree: HASH_TABLE [INTEGER, INTEGER]
			l_queue: ARRAYED_QUEUE [INTEGER]
			l_current, l_deg: INTEGER
			l_nodes, l_neighbors: ARRAYED_LIST [INTEGER]
			l_edges: detachable ARRAYED_LIST [SIMPLE_GRAPH_EDGE]
			l_edge: SIMPLE_GRAPH_EDGE
		do
			create Result.make (node_count)
			create l_in_degree.make (node_count)
			create l_queue.make (node_count)

			-- Initialize in-degrees to 0
			l_nodes := all_nodes
			from l_nodes.start
			until l_nodes.after
			loop
				l_in_degree.put (0, l_nodes.item)
				l_nodes.forth
			end

			-- Calculate in-degrees
			from adjacency.start
			until adjacency.after
			loop
				l_edges := adjacency.item_for_iteration
				if l_edges /= Void then
					from l_edges.start
					until l_edges.after
					loop
						l_edge := l_edges.item
						l_deg := l_in_degree.item (l_edge.to_node)
						l_in_degree.force (l_deg + 1, l_edge.to_node)
						l_edges.forth
					end
				end
				adjacency.forth
			end

			-- Start with nodes having in-degree 0
			from l_in_degree.start
			until l_in_degree.after
			loop
				if l_in_degree.item_for_iteration = 0 then
					l_queue.put (l_in_degree.key_for_iteration)
				end
				l_in_degree.forth
			end

			from
			until l_queue.is_empty
			loop
				l_current := l_queue.item
				l_queue.remove
				Result.extend (l_current)

				l_neighbors := neighbors (l_current)
				from l_neighbors.start
				until l_neighbors.after
				loop
					l_deg := l_in_degree.item (l_neighbors.item)
					l_in_degree.force (l_deg - 1, l_neighbors.item)
					if l_deg - 1 = 0 then
						l_queue.put (l_neighbors.item)
					end
					l_neighbors.forth
				end
			end

			-- If not all nodes processed, graph has a cycle
			if Result.count /= node_count then
				Result.wipe_out
			end
		ensure
			empty_if_cycle: has_cycle implies Result.is_empty
		end

	degree (a_id: INTEGER): INTEGER
			-- Number of edges connected to node `a_id'.
		require
			has_node: has_node (a_id)
		local
			l_edges: detachable ARRAYED_LIST [SIMPLE_GRAPH_EDGE]
		do
			l_edges := adjacency.item (a_id)
			if l_edges /= Void then
				Result := l_edges.count
			end
		end

	in_degree (a_id: INTEGER): INTEGER
			-- Number of incoming edges to node `a_id' (directed graphs).
		require
			has_node: has_node (a_id)
		local
			l_edges: detachable ARRAYED_LIST [SIMPLE_GRAPH_EDGE]
			l_edge: SIMPLE_GRAPH_EDGE
		do
			from adjacency.start
			until adjacency.after
			loop
				l_edges := adjacency.item_for_iteration
				if l_edges /= Void then
					from l_edges.start
					until l_edges.after
					loop
						l_edge := l_edges.item
						if l_edge.to_node = a_id then
							Result := Result + 1
						end
						l_edges.forth
					end
				end
				adjacency.forth
			end
		end

	out_degree (a_id: INTEGER): INTEGER
			-- Number of outgoing edges from node `a_id' (directed graphs).
		require
			has_node: has_node (a_id)
		local
			l_edges: detachable ARRAYED_LIST [SIMPLE_GRAPH_EDGE]
		do
			l_edges := adjacency.item (a_id)
			if l_edges /= Void then
				Result := l_edges.count
			end
		end

feature {NONE} -- Implementation

	nodes: HASH_TABLE [G, INTEGER]
			-- Node data indexed by ID.

	adjacency: HASH_TABLE [ARRAYED_LIST [SIMPLE_GRAPH_EDGE], INTEGER]
			-- Adjacency list for each node.

	next_id: INTEGER
			-- Next available node ID.

	has_cycle_dfs (a_node: INTEGER; a_visited: HASH_TABLE [INTEGER, INTEGER]; a_parent: INTEGER): BOOLEAN
			-- Helper for cycle detection using DFS.
		local
			l_neighbor: INTEGER
			l_neighbors: ARRAYED_LIST [INTEGER]
		do
			a_visited.force (1, a_node)  -- Mark as gray (in progress)
			l_neighbors := neighbors (a_node)
			from l_neighbors.start
			until l_neighbors.after or Result
			loop
				l_neighbor := l_neighbors.item
				if a_visited.item (l_neighbor) = 0 then
					Result := has_cycle_dfs (l_neighbor, a_visited, a_node)
				elseif is_directed then
					-- For directed: back edge to gray node = cycle
					if a_visited.item (l_neighbor) = 1 then
						Result := True
					end
				else
					-- For undirected: visiting non-parent gray node = cycle
					if l_neighbor /= a_parent then
						Result := True
					end
				end
				l_neighbors.forth
			end
			a_visited.force (2, a_node)  -- Mark as black (done)
		end

invariant
	valid_next_id: next_id >= 1

end
