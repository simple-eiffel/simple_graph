# S04 - Feature Specifications

**Library:** simple_graph
**Status:** BACKWASH (reverse-engineered from implementation)
**Generated:** 2026-01-23

## SIMPLE_GRAPH [G] Features

### Initialization

| Feature | Signature | Description |
|---------|-----------|-------------|
| make | () | Create undirected graph |
| make_directed | () | Create directed graph |

### Access (Queries)

| Feature | Returns | Description |
|---------|---------|-------------|
| is_directed | BOOLEAN | Is this a directed graph? |
| node_count | INTEGER | Number of nodes in graph |
| edge_count | INTEGER | Number of edges in graph |
| is_empty | BOOLEAN | Is the graph empty? |
| has_node (a_id) | BOOLEAN | Does graph contain node? |
| has_edge (a_from, a_to) | BOOLEAN | Does graph contain edge? |
| node (a_id) | detachable G | Data for node with ID |
| neighbors (a_id) | ARRAYED_LIST [INTEGER] | List of neighbor node IDs |
| edge_weight (a_from, a_to) | REAL_64 | Weight of edge |
| all_nodes | ARRAYED_LIST [INTEGER] | List of all node IDs |
| all_edges | ARRAYED_LIST [TUPLE [...]] | List of all edges as tuples |

### Model Queries

| Feature | Returns | Description |
|---------|---------|-------------|
| model_nodes | MML_SET [INTEGER] | Set of all node IDs |
| model_edges | MML_RELATION [INTEGER, INTEGER] | Relation of edge pairs |
| model_adjacency | MML_MAP [INTEGER, MML_SET [INTEGER]] | Map of node to neighbors |

### Node Operations (Commands)

| Feature | Signature | Returns | Description |
|---------|-----------|---------|-------------|
| add_node | (a_data: G) | INTEGER | Add node, return ID |
| add_node_with_id | (a_id: INTEGER; a_data: G) | void | Add node with specific ID |
| remove_node | (a_id: INTEGER) | void | Remove node and all its edges |

### Edge Operations (Commands)

| Feature | Signature | Description |
|---------|-----------|-------------|
| add_edge | (a_from, a_to: INTEGER) | Add edge with weight 1.0 |
| add_edge_weighted | (a_from, a_to: INTEGER; a_weight: REAL_64) | Add weighted edge |
| remove_edge | (a_from, a_to: INTEGER) | Remove edge |

### Graph Operations (Commands)

| Feature | Signature | Description |
|---------|-----------|-------------|
| clear | () | Remove all nodes and edges |

### Traversal Algorithms

| Feature | Signature | Returns | Description |
|---------|-----------|---------|-------------|
| bfs | (a_start: INTEGER) | ARRAYED_LIST [INTEGER] | Breadth-first traversal |
| dfs | (a_start: INTEGER) | ARRAYED_LIST [INTEGER] | Depth-first traversal |

### Shortest Path Algorithms

| Feature | Signature | Returns | Description |
|---------|-----------|---------|-------------|
| dijkstra | (a_start, a_end: INTEGER) | ARRAYED_LIST [INTEGER] | Shortest path (empty if none) |
| shortest_distance | (a_start, a_end: INTEGER) | REAL_64 | Shortest distance (-1 if none) |

### Analysis Algorithms

| Feature | Returns | Description |
|---------|---------|-------------|
| is_connected | BOOLEAN | Are all nodes reachable from any node? |
| has_cycle | BOOLEAN | Does graph contain a cycle? |
| topological_sort | ARRAYED_LIST [INTEGER] | Topological ordering (DAG only) |

### Degree Queries

| Feature | Signature | Returns | Description |
|---------|-----------|---------|-------------|
| degree | (a_id: INTEGER) | INTEGER | Number of edges connected to node |
| in_degree | (a_id: INTEGER) | INTEGER | Number of incoming edges (directed) |
| out_degree | (a_id: INTEGER) | INTEGER | Number of outgoing edges (directed) |

---

## SIMPLE_GRAPH_EDGE Features

### Initialization

| Feature | Signature | Description |
|---------|-----------|-------------|
| make | (a_to: INTEGER; a_weight: REAL_64) | Create weighted edge |
| make_unweighted | (a_to: INTEGER) | Create edge with weight 1.0 |

### Access

| Feature | Returns | Description |
|---------|---------|-------------|
| to_node | INTEGER | Target node ID |
| weight | REAL_64 | Edge weight |

### Comparison

| Feature | Signature | Returns | Description |
|---------|-----------|---------|-------------|
| is_equal_edge | (other: SIMPLE_GRAPH_EDGE) | BOOLEAN | Are edges equal? |

### Output

| Feature | Returns | Description |
|---------|---------|-------------|
| out | STRING | String representation |

---

## Algorithm Details

### BFS (Breadth-First Search)
- Uses ARRAYED_QUEUE for level-order traversal
- Visits each reachable node exactly once
- Returns nodes in order of distance from start
- Time: O(V + E), Space: O(V)

### DFS (Depth-First Search)
- Uses ARRAYED_STACK for depth-first traversal
- Visits each reachable node exactly once
- Returns nodes in depth-first order
- Time: O(V + E), Space: O(V)

### Dijkstra's Algorithm
- Finds shortest path between two nodes
- Uses naive min-search (not priority queue)
- Handles weighted graphs
- Returns empty list if no path exists
- Time: O(V^2), Space: O(V)

### Topological Sort (Kahn's Algorithm)
- Only valid for directed acyclic graphs (DAGs)
- Uses in-degree counting and queue
- Returns empty list if graph has cycle
- Time: O(V + E), Space: O(V)

### Cycle Detection
- Uses DFS with three-color marking (white/gray/black)
- Handles both directed and undirected graphs
- For undirected: detects back-edges to non-parent
- For directed: detects back-edges to gray nodes
- Time: O(V + E), Space: O(V)

### Connectivity Check
- Uses BFS from first node
- Connected if BFS visits all nodes
- Empty graph considered connected
- Time: O(V + E), Space: O(V)
