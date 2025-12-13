note
	description: "Tests for SIMPLE_GRAPH library"
	author: "Larry Rix"

class
	LIB_TESTS

inherit
	TEST_SET_BASE

feature -- Test: Creation

	test_make_undirected
			-- Test creating undirected graph.
		local
			g: SIMPLE_GRAPH [STRING]
		do
			create g.make
			check not_directed: not g.is_directed end
			check empty: g.is_empty end
			check zero_nodes: g.node_count = 0 end
			check zero_edges: g.edge_count = 0 end
		end

	test_make_directed
			-- Test creating directed graph.
		local
			g: SIMPLE_GRAPH [STRING]
		do
			create g.make_directed
			check directed: g.is_directed end
			check empty: g.is_empty end
		end

feature -- Test: Nodes

	test_add_node
			-- Test adding nodes.
		local
			g: SIMPLE_GRAPH [STRING]
			id1, id2: INTEGER
		do
			create g.make
			id1 := g.add_node ("A")
			id2 := g.add_node ("B")
			check node_count: g.node_count = 2 end
			check has_node_1: g.has_node (id1) end
			check has_node_2: g.has_node (id2) end
			check different_ids: id1 /= id2 end
		end

	test_add_node_with_id
			-- Test adding node with specific ID.
		local
			g: SIMPLE_GRAPH [INTEGER]
		do
			create g.make
			g.add_node_with_id (100, 42)
			check has_node: g.has_node (100) end
			check node_data: g.node (100) = 42 end
		end

	test_node_data
			-- Test retrieving node data.
		local
			g: SIMPLE_GRAPH [STRING]
			id: INTEGER
		do
			create g.make
			id := g.add_node ("Hello")
			check data_correct: attached g.node (id) as d and then d.same_string ("Hello") end
		end

	test_remove_node
			-- Test removing a node.
		local
			g: SIMPLE_GRAPH [STRING]
			id1, id2: INTEGER
		do
			create g.make
			id1 := g.add_node ("A")
			id2 := g.add_node ("B")
			g.add_edge (id1, id2)
			g.remove_node (id1)
			check node_removed: not g.has_node (id1) end
			check other_remains: g.has_node (id2) end
			check count_decreased: g.node_count = 1 end
		end

feature -- Test: Edges

	test_add_edge_undirected
			-- Test adding edge in undirected graph.
		local
			g: SIMPLE_GRAPH [STRING]
			id1, id2: INTEGER
		do
			create g.make
			id1 := g.add_node ("A")
			id2 := g.add_node ("B")
			g.add_edge (id1, id2)
			check has_edge_forward: g.has_edge (id1, id2) end
			check has_edge_backward: g.has_edge (id2, id1) end
			check edge_count: g.edge_count = 1 end
		end

	test_add_edge_directed
			-- Test adding edge in directed graph.
		local
			g: SIMPLE_GRAPH [STRING]
			id1, id2: INTEGER
		do
			create g.make_directed
			id1 := g.add_node ("A")
			id2 := g.add_node ("B")
			g.add_edge (id1, id2)
			check has_edge_forward: g.has_edge (id1, id2) end
			check no_edge_backward: not g.has_edge (id2, id1) end
			check edge_count: g.edge_count = 1 end
		end

	test_add_edge_weighted
			-- Test adding weighted edge.
		local
			g: SIMPLE_GRAPH [STRING]
			id1, id2: INTEGER
		do
			create g.make
			id1 := g.add_node ("A")
			id2 := g.add_node ("B")
			g.add_edge_weighted (id1, id2, 3.5)
			check has_edge: g.has_edge (id1, id2) end
			check weight_correct: g.edge_weight (id1, id2) = 3.5 end
		end

	test_remove_edge
			-- Test removing an edge.
		local
			g: SIMPLE_GRAPH [STRING]
			id1, id2: INTEGER
		do
			create g.make
			id1 := g.add_node ("A")
			id2 := g.add_node ("B")
			g.add_edge (id1, id2)
			g.remove_edge (id1, id2)
			check edge_removed: not g.has_edge (id1, id2) end
			check nodes_remain: g.node_count = 2 end
		end

	test_neighbors
			-- Test getting neighbors.
		local
			g: SIMPLE_GRAPH [STRING]
			id1, id2, id3: INTEGER
			n: ARRAYED_LIST [INTEGER]
		do
			create g.make
			id1 := g.add_node ("A")
			id2 := g.add_node ("B")
			id3 := g.add_node ("C")
			g.add_edge (id1, id2)
			g.add_edge (id1, id3)
			n := g.neighbors (id1)
			check two_neighbors: n.count = 2 end
			check has_b: n.has (id2) end
			check has_c: n.has (id3) end
		end

feature -- Test: Traversal

	test_bfs
			-- Test breadth-first search.
		local
			g: SIMPLE_GRAPH [STRING]
			id1, id2, id3, id4: INTEGER
			l_result: ARRAYED_LIST [INTEGER]
		do
			create g.make
			id1 := g.add_node ("A")
			id2 := g.add_node ("B")
			id3 := g.add_node ("C")
			id4 := g.add_node ("D")
			g.add_edge (id1, id2)
			g.add_edge (id1, id3)
			g.add_edge (id2, id4)
			l_result := g.bfs (id1)
			check visits_all: l_result.count = 4 end
			check starts_at_start: l_result.first = id1 end
		end

	test_dfs
			-- Test depth-first search.
		local
			g: SIMPLE_GRAPH [STRING]
			id1, id2, id3, id4: INTEGER
			l_result: ARRAYED_LIST [INTEGER]
		do
			create g.make
			id1 := g.add_node ("A")
			id2 := g.add_node ("B")
			id3 := g.add_node ("C")
			id4 := g.add_node ("D")
			g.add_edge (id1, id2)
			g.add_edge (id1, id3)
			g.add_edge (id2, id4)
			l_result := g.dfs (id1)
			check visits_all: l_result.count = 4 end
			check starts_at_start: l_result.first = id1 end
		end

feature -- Test: Shortest Path

	test_dijkstra_simple
			-- Test Dijkstra's algorithm on simple graph.
		local
			g: SIMPLE_GRAPH [STRING]
			id1, id2, id3: INTEGER
			path: ARRAYED_LIST [INTEGER]
		do
			create g.make
			id1 := g.add_node ("A")
			id2 := g.add_node ("B")
			id3 := g.add_node ("C")
			g.add_edge (id1, id2)
			g.add_edge (id2, id3)
			path := g.dijkstra (id1, id3)
			check path_found: not path.is_empty end
			check starts_at_a: path.first = id1 end
			check ends_at_c: path.last = id3 end
			check path_length: path.count = 3 end
		end

	test_dijkstra_weighted
			-- Test Dijkstra's with weighted edges.
		local
			g: SIMPLE_GRAPH [STRING]
			id1, id2, id3: INTEGER
			path: ARRAYED_LIST [INTEGER]
		do
			create g.make
			id1 := g.add_node ("A")
			id2 := g.add_node ("B")
			id3 := g.add_node ("C")
			-- Direct path A->C has weight 10
			g.add_edge_weighted (id1, id3, 10.0)
			-- Path A->B->C has weight 2+3=5
			g.add_edge_weighted (id1, id2, 2.0)
			g.add_edge_weighted (id2, id3, 3.0)
			path := g.dijkstra (id1, id3)
			-- Should take the shorter weighted path through B
			check path_through_b: path.count = 3 and path [2] = id2 end
		end

	test_dijkstra_no_path
			-- Test Dijkstra's when no path exists.
		local
			g: SIMPLE_GRAPH [STRING]
			id1, id2: INTEGER
			path: ARRAYED_LIST [INTEGER]
		do
			create g.make_directed
			id1 := g.add_node ("A")
			id2 := g.add_node ("B")
			-- No edge between them
			path := g.dijkstra (id1, id2)
			check no_path: path.is_empty end
		end

	test_shortest_distance
			-- Test shortest distance calculation.
		local
			g: SIMPLE_GRAPH [STRING]
			id1, id2, id3: INTEGER
			dist: REAL_64
		do
			create g.make
			id1 := g.add_node ("A")
			id2 := g.add_node ("B")
			id3 := g.add_node ("C")
			g.add_edge_weighted (id1, id2, 2.0)
			g.add_edge_weighted (id2, id3, 3.0)
			dist := g.shortest_distance (id1, id3)
			check distance_correct: dist = 5.0 end
		end

feature -- Test: Analysis

	test_is_connected_true
			-- Test connected graph detection.
		local
			g: SIMPLE_GRAPH [STRING]
			id1, id2, id3: INTEGER
		do
			create g.make
			id1 := g.add_node ("A")
			id2 := g.add_node ("B")
			id3 := g.add_node ("C")
			g.add_edge (id1, id2)
			g.add_edge (id2, id3)
			check connected: g.is_connected end
		end

	test_is_connected_false
			-- Test disconnected graph detection.
		local
			g: SIMPLE_GRAPH [STRING]
			id1, id2, id3: INTEGER
		do
			create g.make
			id1 := g.add_node ("A")
			id2 := g.add_node ("B")
			id3 := g.add_node ("C")
			g.add_edge (id1, id2)
			-- id3 is isolated
			check not_connected: not g.is_connected end
		end

	test_has_cycle_undirected
			-- Test cycle detection in undirected graph.
		local
			g: SIMPLE_GRAPH [STRING]
			id1, id2, id3: INTEGER
		do
			create g.make
			id1 := g.add_node ("A")
			id2 := g.add_node ("B")
			id3 := g.add_node ("C")
			g.add_edge (id1, id2)
			g.add_edge (id2, id3)
			g.add_edge (id3, id1)  -- Creates cycle
			check has_cycle: g.has_cycle end
		end

	test_has_cycle_directed
			-- Test cycle detection in directed graph.
		local
			g: SIMPLE_GRAPH [STRING]
			id1, id2, id3: INTEGER
		do
			create g.make_directed
			id1 := g.add_node ("A")
			id2 := g.add_node ("B")
			id3 := g.add_node ("C")
			g.add_edge (id1, id2)
			g.add_edge (id2, id3)
			g.add_edge (id3, id1)  -- Creates cycle
			check has_cycle: g.has_cycle end
		end

	test_no_cycle
			-- Test acyclic graph detection.
		local
			g: SIMPLE_GRAPH [STRING]
			id1, id2, id3: INTEGER
		do
			create g.make_directed
			id1 := g.add_node ("A")
			id2 := g.add_node ("B")
			id3 := g.add_node ("C")
			g.add_edge (id1, id2)
			g.add_edge (id2, id3)
			-- No cycle
			check no_cycle: not g.has_cycle end
		end

	test_topological_sort
			-- Test topological sorting.
		local
			g: SIMPLE_GRAPH [STRING]
			id1, id2, id3, id4: INTEGER
			sorted: ARRAYED_LIST [INTEGER]
			pos1, pos2, pos3, pos4: INTEGER
		do
			create g.make_directed
			id1 := g.add_node ("A")
			id2 := g.add_node ("B")
			id3 := g.add_node ("C")
			id4 := g.add_node ("D")
			g.add_edge (id1, id2)  -- A -> B
			g.add_edge (id1, id3)  -- A -> C
			g.add_edge (id2, id4)  -- B -> D
			g.add_edge (id3, id4)  -- C -> D
			sorted := g.topological_sort
			check all_included: sorted.count = 4 end
			pos1 := sorted.index_of (id1, 1)
			pos2 := sorted.index_of (id2, 1)
			pos3 := sorted.index_of (id3, 1)
			pos4 := sorted.index_of (id4, 1)
			check a_before_b: pos1 < pos2 end
			check a_before_c: pos1 < pos3 end
			check b_before_d: pos2 < pos4 end
			check c_before_d: pos3 < pos4 end
		end

	test_topological_sort_cycle
			-- Test topological sort returns empty on cycle.
		local
			g: SIMPLE_GRAPH [STRING]
			id1, id2, id3: INTEGER
			sorted: ARRAYED_LIST [INTEGER]
		do
			create g.make_directed
			id1 := g.add_node ("A")
			id2 := g.add_node ("B")
			id3 := g.add_node ("C")
			g.add_edge (id1, id2)
			g.add_edge (id2, id3)
			g.add_edge (id3, id1)  -- Creates cycle
			sorted := g.topological_sort
			check empty_on_cycle: sorted.is_empty end
		end

	test_degree
			-- Test degree calculation.
		local
			g: SIMPLE_GRAPH [STRING]
			id1, id2, id3: INTEGER
		do
			create g.make
			id1 := g.add_node ("A")
			id2 := g.add_node ("B")
			id3 := g.add_node ("C")
			g.add_edge (id1, id2)
			g.add_edge (id1, id3)
			check degree_a: g.degree (id1) = 2 end
			check degree_b: g.degree (id2) = 1 end
		end

	test_in_out_degree
			-- Test in-degree and out-degree for directed graphs.
		local
			g: SIMPLE_GRAPH [STRING]
			id1, id2, id3: INTEGER
		do
			create g.make_directed
			id1 := g.add_node ("A")
			id2 := g.add_node ("B")
			id3 := g.add_node ("C")
			g.add_edge (id1, id2)
			g.add_edge (id1, id3)
			g.add_edge (id2, id3)
			check out_degree_a: g.out_degree (id1) = 2 end
			check in_degree_a: g.in_degree (id1) = 0 end
			check out_degree_c: g.out_degree (id3) = 0 end
			check in_degree_c: g.in_degree (id3) = 2 end
		end

feature -- Test: Utility

	test_clear
			-- Test clearing the graph.
		local
			g: SIMPLE_GRAPH [STRING]
			id1, id2: INTEGER
		do
			create g.make
			id1 := g.add_node ("A")
			id2 := g.add_node ("B")
			g.add_edge (id1, id2)
			g.clear
			check empty: g.is_empty end
			check no_nodes: g.node_count = 0 end
			check no_edges: g.edge_count = 0 end
		end

	test_all_nodes
			-- Test getting all node IDs.
		local
			g: SIMPLE_GRAPH [STRING]
			id1, id2, id3: INTEGER
			l_all: ARRAYED_LIST [INTEGER]
		do
			create g.make
			id1 := g.add_node ("A")
			id2 := g.add_node ("B")
			id3 := g.add_node ("C")
			l_all := g.all_nodes
			check count_correct: l_all.count = 3 end
			check has_all: l_all.has (id1) and l_all.has (id2) and l_all.has (id3) end
		end

	test_all_edges
			-- Test getting all edges.
		local
			g: SIMPLE_GRAPH [STRING]
			id1, id2, id3: INTEGER
			l_all: ARRAYED_LIST [TUPLE [from_node, to_node: INTEGER; weight: REAL_64]]
		do
			create g.make
			id1 := g.add_node ("A")
			id2 := g.add_node ("B")
			id3 := g.add_node ("C")
			g.add_edge (id1, id2)
			g.add_edge (id2, id3)
			l_all := g.all_edges
			check count_correct: l_all.count = 2 end
		end

feature -- Test: Edge

	test_edge_make
			-- Test edge creation.
		local
			e: SIMPLE_GRAPH_EDGE
		do
			create e.make (5, 2.5)
			check to_correct: e.to_node = 5 end
			check weight_correct: e.weight = 2.5 end
		end

	test_edge_make_unweighted
			-- Test unweighted edge creation.
		local
			e: SIMPLE_GRAPH_EDGE
		do
			create e.make_unweighted (3)
			check to_correct: e.to_node = 3 end
			check default_weight: e.weight = 1.0 end
		end

end
