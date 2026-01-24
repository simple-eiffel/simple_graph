# S06 - Boundaries

**Library:** simple_graph
**Status:** BACKWASH (reverse-engineered from implementation)
**Generated:** 2026-01-23

## Scope Boundaries

### In Scope

1. **Graph Structure**
   - Directed and undirected graphs
   - Weighted edges
   - Generic node data
   - Integer node IDs

2. **Node Operations**
   - Add nodes (auto ID or specified ID)
   - Remove nodes
   - Query node existence
   - Access node data

3. **Edge Operations**
   - Add edges (weighted or unweighted)
   - Remove edges
   - Query edge existence
   - Access edge weight

4. **Traversal Algorithms**
   - Breadth-first search (BFS)
   - Depth-first search (DFS)

5. **Path Algorithms**
   - Dijkstra's shortest path
   - Shortest distance computation

6. **Analysis Algorithms**
   - Connectivity check
   - Cycle detection
   - Topological sorting (DAGs)

7. **Degree Queries**
   - Total degree
   - In-degree (directed)
   - Out-degree (directed)

8. **Model Specification**
   - MML-based model queries
   - Contract verification support

### Out of Scope

1. **Advanced Algorithms**
   - Bellman-Ford (negative weights)
   - Floyd-Warshall (all-pairs)
   - A* search
   - Minimum spanning tree (Prim/Kruskal)
   - Strongly connected components (Tarjan)
   - Maximum flow
   - Bipartite matching

2. **Graph Types**
   - Multigraphs (multiple edges between same nodes)
   - Hypergraphs
   - Attributed graphs (edge properties beyond weight)

3. **Persistence**
   - Serialization/deserialization
   - Graph database integration
   - File format support (GraphML, DOT, etc.)

4. **Visualization**
   - Layout algorithms
   - Rendering
   - Export to image formats

5. **Distributed Graphs**
   - Partitioning
   - Distributed algorithms

6. **Dynamic Algorithms**
   - Incremental updates
   - Streaming graphs

## API Boundaries

### Public API

All features in SIMPLE_GRAPH and SIMPLE_GRAPH_EDGE are public.

### Internal API (feature {NONE})

| Class | Feature | Purpose |
|-------|---------|---------|
| SIMPLE_GRAPH | nodes | Node data storage |
| SIMPLE_GRAPH | adjacency | Adjacency list storage |
| SIMPLE_GRAPH | next_id | ID generator |
| SIMPLE_GRAPH | has_cycle_dfs | Cycle detection helper |

### Extension Points

1. **SIMPLE_GRAPH**
   - Can be inherited for specialized graphs
   - Model queries can be overridden
   - Algorithms can be overridden

2. **SIMPLE_GRAPH_EDGE**
   - Can be inherited for extended edge types
   - Consider adding edge ID, labels, timestamps

## Dependency Boundaries

### Required Dependencies
- EiffelStudio base library (HASH_TABLE, ARRAYED_LIST, etc.)
- MML (Mathematical Model Library) for contracts

### Optional Dependencies
- None

### No Dependencies On
- Network libraries
- Database libraries
- Visualization libraries
- File I/O libraries
- Other simple_* libraries

## Data Boundaries

### Input Boundaries
- Node data: Any type matching G constraint
- Node IDs: Positive integers
- Edge weights: REAL_64

### Output Boundaries
- Node lists: ARRAYED_LIST [INTEGER]
- Edge lists: ARRAYED_LIST [TUPLE [from_node, to_node: INTEGER; weight: REAL_64]]
- Paths: ARRAYED_LIST [INTEGER]
- Distances: REAL_64 (-1.0 for no path)

### Size Limits
- Maximum nodes: ~2 billion (INTEGER limit)
- Maximum edges: Memory-limited
- Maximum path length: Node count

## Error Boundaries

### Precondition Violations
- Invalid node ID (not exists)
- Invalid edge (not exists)
- Wrong graph type (topological_sort on undirected)

### Handled Gracefully
- No path exists: Return empty list or -1.0
- Cycle in topological sort: Return empty list
- Empty graph connectivity: Return True

### Not Handled
- Out of memory
- Integer overflow in node IDs
- Negative weights in Dijkstra (undefined behavior)

## Performance Boundaries

### Suitable For
- Small to medium graphs (< 100K nodes)
- Sparse graphs (E << V^2)
- Single shortest path queries
- Basic traversal operations

### Not Suitable For
- Large graphs (> 1M nodes without optimization)
- Dense graphs (adjacency matrix better)
- Many shortest path queries (precompute needed)
- Real-time applications (no incremental updates)
- High-concurrency scenarios (not thread-safe)
