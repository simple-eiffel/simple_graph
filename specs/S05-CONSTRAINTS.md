# S05 - Constraints

**Library:** simple_graph
**Status:** BACKWASH (reverse-engineered from implementation)
**Generated:** 2026-01-23

## Type Constraints

### Generic Parameter
```eiffel
G -> detachable separate ANY
```
- `detachable`: Node data can be Void
- `separate`: SCOOP-compatible for concurrent access
- `ANY`: Any Eiffel type allowed

### Node ID Constraints
- Node IDs are positive integers (> 0)
- IDs are auto-generated sequentially starting from 1
- Custom IDs must be positive and not already in use
- IDs are stable (survive graph mutations)

### Edge Weight Constraints
- Weights are REAL_64 (double precision)
- Default weight is 1.0
- Dijkstra requires non-negative weights for correctness
- No explicit constraint on negative weights (undefined behavior)

## Operational Constraints

### Graph Type
- Graph type (directed/undirected) is set at creation
- Cannot change after creation
- Undirected edges automatically create reverse edge

### Self-Loops
- Self-loops (a_from = a_to) are allowed
- For undirected graphs, self-loops are not duplicated

### Multi-Edges
- Adding same edge twice overwrites (last weight wins)
- No explicit multi-edge support

### Node Removal
- Removing a node removes all incident edges
- Both incoming and outgoing edges removed

### Edge Removal (Undirected)
- Removing edge from A to B also removes B to A

## Algorithm Constraints

### BFS/DFS
- Requires valid start node
- Only visits nodes reachable from start
- Does not visit disconnected components

### Dijkstra
- Requires valid start and end nodes
- Assumes non-negative edge weights
- Returns empty list if no path exists
- Returns -1.0 for shortest_distance if no path
- Performance: O(V^2) with naive min-search

### Topological Sort
- Only valid for directed graphs (precondition)
- Returns empty list if cycle exists
- Order is one valid topological ordering (not unique)

### Cycle Detection
- Works for both directed and undirected graphs
- Uses DFS with three-color marking
- Handles disconnected components

## Memory Constraints

### Space Complexity
- Node storage: O(V)
- Edge storage: O(E) for directed, O(2E) for undirected
- Total: O(V + E)

### Large Graphs
- No explicit size limit
- INTEGER node IDs limit to ~2 billion nodes
- Memory limited by available RAM

## Performance Constraints

### Time Complexity Summary

| Operation | Time |
|-----------|------|
| add_node | O(1) amortized |
| add_edge | O(1) amortized |
| has_node | O(1) |
| has_edge | O(degree) |
| neighbors | O(degree) |
| edge_weight | O(degree) |
| remove_node | O(V + degree) |
| remove_edge | O(degree) |
| node_count | O(1) |
| edge_count | O(V + E) |
| bfs/dfs | O(V + E) |
| dijkstra | O(V^2) |
| topological_sort | O(V + E) |
| has_cycle | O(V + E) |
| is_connected | O(V + E) |

### Bottlenecks
- `edge_count` iterates all adjacency lists
- Dijkstra uses naive min-search (could be O(E log V) with priority queue)
- `has_edge` linear search in adjacency list (could be O(log degree) with sorted list)

## Contract Constraints

### Model Query Cost
- model_nodes: O(V)
- model_edges: O(E)
- model_adjacency: O(V + E)
- Model queries should not be used in performance-critical code

### Assertion Checking
- When assertions enabled, postconditions may be expensive
- model_edges postcondition is O(E)
- Consider disabling assertions in production

## Thread Safety Constraints

### SCOOP Compatibility
- Generic parameter allows separate types
- No internal synchronization
- Client responsible for SCOOP regions

### Concurrent Modification
- Not thread-safe
- Iteration during modification: undefined behavior
- Use external synchronization for concurrent access
