# S07 - Specification Summary

**Library:** simple_graph
**Status:** BACKWASH (reverse-engineered from implementation)
**Generated:** 2026-01-23

## Executive Summary

simple_graph is a generic graph data structure library for Eiffel that provides:

1. **SIMPLE_GRAPH [G]** - Main graph class with adjacency list representation
2. **SIMPLE_GRAPH_EDGE** - Edge representation with weight

The library supports both directed and undirected graphs with weighted edges, and includes standard graph algorithms for traversal, shortest paths, and analysis.

## Key Design Decisions

### 1. Adjacency List Representation
Chosen for space efficiency with sparse graphs:
- Space: O(V + E) vs O(V^2) for matrix
- Best for typical real-world graphs

### 2. Integer Node IDs
Nodes identified by auto-generated integers:
- Avoids NetworkX-style object identity confusion
- O(1) lookup via hash table
- Stable across mutations

### 3. Generic Node Data
Payload stored separately from topology:
- Any Eiffel type as node data
- Type-safe access
- SCOOP-compatible (detachable separate ANY)

### 4. Undirected as Symmetric Directed
Undirected edges stored as two directed edges:
- Simplifies implementation
- Consistent neighbor iteration
- Slight memory overhead

### 5. MML Model Queries
Mathematical Model Library for contracts:
- Precise postcondition specification
- Formal verification support
- Clear invariant expression

## API Surface Summary

| Class | Purpose | Feature Count |
|-------|---------|---------------|
| SIMPLE_GRAPH | Graph operations and algorithms | ~45 |
| SIMPLE_GRAPH_EDGE | Edge representation | ~7 |

## Algorithm Summary

| Algorithm | Purpose | Complexity |
|-----------|---------|------------|
| BFS | Level-order traversal | O(V + E) |
| DFS | Depth-first traversal | O(V + E) |
| Dijkstra | Shortest path | O(V^2) |
| Topological Sort | DAG ordering | O(V + E) |
| Cycle Detection | Find cycles | O(V + E) |
| Connectivity | Check connected | O(V + E) |

## Contract Summary

| Contract Type | Count | Coverage |
|---------------|-------|----------|
| Preconditions | 15 | All mutation and query operations |
| Postconditions | 20 | All mutation operations |
| Invariants | 3 | Graph consistency |
| Model Queries | 3 | nodes, edges, adjacency |

## Usage Patterns

### Creating a Graph
```eiffel
-- Undirected graph
create graph.make

-- Directed graph
create graph.make_directed
```

### Adding Nodes and Edges
```eiffel
a := graph.add_node ("A")
b := graph.add_node ("B")
graph.add_edge (a, b)
graph.add_edge_weighted (a, b, 5.0)
```

### Finding Shortest Path
```eiffel
path := graph.dijkstra (start_id, end_id)
if path.is_empty then
    print ("No path exists")
else
    distance := graph.shortest_distance (start_id, end_id)
end
```

### Traversal
```eiffel
-- BFS from node 1
visited := graph.bfs (1)

-- DFS from node 1
visited := graph.dfs (1)
```

### Analysis
```eiffel
if graph.is_connected then
    print ("Graph is connected")
end

if not graph.has_cycle and graph.is_directed then
    order := graph.topological_sort
end
```

## Testing Strategy

1. **Unit Tests**: Individual operations (add/remove node/edge)
2. **Algorithm Tests**: Verify BFS, DFS, Dijkstra correctness
3. **Edge Cases**: Empty graph, single node, disconnected, cycles
4. **Contract Tests**: Verify pre/postconditions and invariants

## Known Limitations

1. Dijkstra is O(V^2) - no priority queue optimization
2. No negative weight support
3. No multi-edge support
4. Not thread-safe
5. No persistence/serialization

## Future Enhancements (Proposed)

1. Priority queue for Dijkstra (O(E log V))
2. A* search algorithm
3. Minimum spanning tree (Prim/Kruskal)
4. Strongly connected components
5. Graph serialization (GraphML, JSON)
6. Visualization support
7. Sorted adjacency lists for O(log degree) edge lookup
