<p align="center">
  <img src="docs/images/logo.svg" alt="simple_graph logo" width="400">
</p>

# simple_graph

**[Documentation](https://simple-eiffel.github.io/simple_graph/)** | **[GitHub](https://github.com/simple-eiffel/simple_graph)**

Generic graph data structures with traversal and shortest path algorithms for Eiffel applications.

## Overview

`simple_graph` provides a generic graph implementation using adjacency lists. It supports both directed and undirected graphs with weighted edges, and includes common graph algorithms.

### Features

- **Generic nodes** - Store any data type in graph nodes
- **Directed and undirected** - Support for both graph types
- **Weighted edges** - Optional edge weights (default: 1.0)
- **BFS/DFS traversal** - Breadth-first and depth-first search
- **Shortest path** - Dijkstra's algorithm
- **Cycle detection** - Detect cycles in both graph types
- **Topological sort** - Order nodes in DAGs
- **Connectivity analysis** - Check if graph is connected

## Installation

1. Clone the repository to `D:\prod`
2. Set the ecosystem environment variable (one-time setup for all simple_* libraries):
   ```
   SIMPLE_EIFFEL=D:\prod
   ```
3. Add to your ECF:

```xml
<library name="simple_graph" location="$SIMPLE_EIFFEL/simple_graph/simple_graph.ecf"/>
```

## Dependencies

- EiffelBase (base)

## Quick Start

```eiffel
local
    g: SIMPLE_GRAPH [STRING]
    a, b, c: INTEGER
    path: ARRAYED_LIST [INTEGER]
do
    -- Create undirected graph
    create g.make

    -- Add nodes (returns node ID)
    a := g.add_node ("Paris")
    b := g.add_node ("London")
    c := g.add_node ("Berlin")

    -- Add edges
    g.add_edge (a, b)
    g.add_edge_weighted (b, c, 2.5)

    -- Check properties
    print ("Nodes: " + g.node_count.out)
    print ("Edges: " + g.edge_count.out)
    print ("Connected: " + g.is_connected.out)

    -- Traversal
    across g.bfs (a) as node loop
        print ("Visited: " + g.node (node.item).out)
    end

    -- Shortest path
    path := g.dijkstra (a, c)
    print ("Path length: " + path.count.out)
    print ("Distance: " + g.shortest_distance (a, c).out)
end
```

## Directed Graphs

```eiffel
local
    g: SIMPLE_GRAPH [STRING]
    a, b, c: INTEGER
    sorted: ARRAYED_LIST [INTEGER]
do
    -- Create directed graph
    create g.make_directed

    a := g.add_node ("Task A")
    b := g.add_node ("Task B")
    c := g.add_node ("Task C")

    g.add_edge (a, b)  -- A -> B
    g.add_edge (a, c)  -- A -> C
    g.add_edge (b, c)  -- B -> C

    -- Check for cycles
    if not g.has_cycle then
        -- Topological sort (DAG only)
        sorted := g.topological_sort
        across sorted as node loop
            print (g.node (node.item).out)
        end
    end

    -- In/out degree
    print ("In-degree of C: " + g.in_degree (c).out)   -- 2
    print ("Out-degree of A: " + g.out_degree (a).out) -- 2
end
```

## Weighted Shortest Path

```eiffel
local
    g: SIMPLE_GRAPH [STRING]
    a, b, c, d: INTEGER
    path: ARRAYED_LIST [INTEGER]
do
    create g.make

    a := g.add_node ("A")
    b := g.add_node ("B")
    c := g.add_node ("C")
    d := g.add_node ("D")

    -- Direct route A-D has weight 10
    g.add_edge_weighted (a, d, 10.0)

    -- Indirect route A-B-C-D has weight 2+3+4=9
    g.add_edge_weighted (a, b, 2.0)
    g.add_edge_weighted (b, c, 3.0)
    g.add_edge_weighted (c, d, 4.0)

    -- Dijkstra finds shortest weighted path
    path := g.dijkstra (a, d)
    -- path = [A, B, C, D] (not [A, D])

    print ("Shortest distance: " + g.shortest_distance (a, d).out)  -- 9.0
end
```

## API Reference

### Creation

| Feature | Description |
|---------|-------------|
| `make` | Create undirected graph |
| `make_directed` | Create directed graph |

### Nodes

| Feature | Description |
|---------|-------------|
| `add_node (data): INTEGER` | Add node, return ID |
| `add_node_with_id (id, data)` | Add node with specific ID |
| `remove_node (id)` | Remove node and its edges |
| `has_node (id): BOOLEAN` | Check if node exists |
| `node (id): G` | Get node data |
| `node_count: INTEGER` | Number of nodes |
| `all_nodes: LIST [INTEGER]` | List all node IDs |

### Edges

| Feature | Description |
|---------|-------------|
| `add_edge (from, to)` | Add edge with weight 1.0 |
| `add_edge_weighted (from, to, weight)` | Add weighted edge |
| `remove_edge (from, to)` | Remove edge |
| `has_edge (from, to): BOOLEAN` | Check if edge exists |
| `edge_weight (from, to): REAL_64` | Get edge weight |
| `edge_count: INTEGER` | Number of edges |
| `all_edges: LIST [TUPLE]` | List all edges |
| `neighbors (id): LIST [INTEGER]` | Get adjacent node IDs |

### Traversal

| Feature | Description |
|---------|-------------|
| `bfs (start): LIST [INTEGER]` | Breadth-first search |
| `dfs (start): LIST [INTEGER]` | Depth-first search |

### Shortest Path

| Feature | Description |
|---------|-------------|
| `dijkstra (start, end): LIST [INTEGER]` | Shortest path (empty if none) |
| `shortest_distance (start, end): REAL_64` | Shortest distance (-1 if none) |

### Analysis

| Feature | Description |
|---------|-------------|
| `is_directed: BOOLEAN` | Is this a directed graph? |
| `is_empty: BOOLEAN` | Is graph empty? |
| `is_connected: BOOLEAN` | Are all nodes reachable? |
| `has_cycle: BOOLEAN` | Does graph contain a cycle? |
| `topological_sort: LIST [INTEGER]` | Topological order (DAG only) |
| `degree (id): INTEGER` | Edge count for node |
| `in_degree (id): INTEGER` | Incoming edges (directed) |
| `out_degree (id): INTEGER` | Outgoing edges (directed) |

### Utility

| Feature | Description |
|---------|-------------|
| `clear` | Remove all nodes and edges |

## Use Cases

- **Dependency resolution** - Package managers, build systems
- **Route planning** - Navigation, network routing
- **Social networks** - Relationship graphs
- **Workflow systems** - Task dependencies
- **Game development** - Pathfinding, state machines

## Design by Contract

```eiffel
invariant
    valid_next_id: next_id >= 1
```

Key preconditions:
- `has_node (a_id)` for node operations
- `has_edge (a_from, a_to)` for edge queries
- `is_directed` for topological_sort

## License

MIT License - Copyright (c) 2024-2025, Larry Rix
