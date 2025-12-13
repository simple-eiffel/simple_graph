note
	description: "Test application for simple_graph"
	author: "Larry Rix"

class
	TEST_APP

create
	make

feature {NONE} -- Initialization

	make
			-- Run tests.
		local
			tests: LIB_TESTS
		do
			create tests
			io.put_string ("simple_graph test runner%N")
			io.put_string ("====================================%N%N")

			passed := 0
			failed := 0

			-- Creation Tests
			io.put_string ("Creation Tests%N")
			io.put_string ("--------------%N")
			run_test (agent tests.test_make_undirected, "test_make_undirected")
			run_test (agent tests.test_make_directed, "test_make_directed")

			-- Node Tests
			io.put_string ("%NNode Tests%N")
			io.put_string ("----------%N")
			run_test (agent tests.test_add_node, "test_add_node")
			run_test (agent tests.test_add_node_with_id, "test_add_node_with_id")
			run_test (agent tests.test_node_data, "test_node_data")
			run_test (agent tests.test_remove_node, "test_remove_node")

			-- Edge Tests
			io.put_string ("%NEdge Tests%N")
			io.put_string ("----------%N")
			run_test (agent tests.test_add_edge_undirected, "test_add_edge_undirected")
			run_test (agent tests.test_add_edge_directed, "test_add_edge_directed")
			run_test (agent tests.test_add_edge_weighted, "test_add_edge_weighted")
			run_test (agent tests.test_remove_edge, "test_remove_edge")
			run_test (agent tests.test_neighbors, "test_neighbors")

			-- Traversal Tests
			io.put_string ("%NTraversal Tests%N")
			io.put_string ("---------------%N")
			run_test (agent tests.test_bfs, "test_bfs")
			run_test (agent tests.test_dfs, "test_dfs")

			-- Shortest Path Tests
			io.put_string ("%NShortest Path Tests%N")
			io.put_string ("-------------------%N")
			run_test (agent tests.test_dijkstra_simple, "test_dijkstra_simple")
			run_test (agent tests.test_dijkstra_weighted, "test_dijkstra_weighted")
			run_test (agent tests.test_dijkstra_no_path, "test_dijkstra_no_path")
			run_test (agent tests.test_shortest_distance, "test_shortest_distance")

			-- Analysis Tests
			io.put_string ("%NAnalysis Tests%N")
			io.put_string ("--------------%N")
			run_test (agent tests.test_is_connected_true, "test_is_connected_true")
			run_test (agent tests.test_is_connected_false, "test_is_connected_false")
			run_test (agent tests.test_has_cycle_undirected, "test_has_cycle_undirected")
			run_test (agent tests.test_has_cycle_directed, "test_has_cycle_directed")
			run_test (agent tests.test_no_cycle, "test_no_cycle")
			run_test (agent tests.test_topological_sort, "test_topological_sort")
			run_test (agent tests.test_topological_sort_cycle, "test_topological_sort_cycle")
			run_test (agent tests.test_degree, "test_degree")
			run_test (agent tests.test_in_out_degree, "test_in_out_degree")

			-- Utility Tests
			io.put_string ("%NUtility Tests%N")
			io.put_string ("-------------%N")
			run_test (agent tests.test_clear, "test_clear")
			run_test (agent tests.test_all_nodes, "test_all_nodes")
			run_test (agent tests.test_all_edges, "test_all_edges")

			-- Edge Class Tests
			io.put_string ("%NEdge Class Tests%N")
			io.put_string ("----------------%N")
			run_test (agent tests.test_edge_make, "test_edge_make")
			run_test (agent tests.test_edge_make_unweighted, "test_edge_make_unweighted")

			io.put_string ("%N====================================%N")
			io.put_string ("Results: " + passed.out + " passed, " + failed.out + " failed%N")

			if failed > 0 then
				io.put_string ("TESTS FAILED%N")
			else
				io.put_string ("ALL TESTS PASSED%N")
			end
		end

feature {NONE} -- Implementation

	passed: INTEGER
	failed: INTEGER

	run_test (a_test: PROCEDURE; a_name: STRING)
			-- Run a single test and update counters.
		local
			l_retried: BOOLEAN
		do
			if not l_retried then
				a_test.call (Void)
				io.put_string ("  PASS: " + a_name + "%N")
				passed := passed + 1
			end
		rescue
			io.put_string ("  FAIL: " + a_name + "%N")
			failed := failed + 1
			l_retried := True
			retry
		end

end
