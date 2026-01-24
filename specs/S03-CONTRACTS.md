# S03 - Contracts

**Library:** simple_graph
**Status:** BACKWASH (reverse-engineered from implementation)
**Generated:** 2026-01-23

## SIMPLE_GRAPH Contracts

### Creation Contracts

#### make
```eiffel
ensure
    not_directed: not is_directed
    empty: is_empty
```

#### make_directed
```eiffel
ensure
    directed: is_directed
    empty: is_empty
```

### Node Operation Contracts

#### add_node (a_data: G): INTEGER
```eiffel
ensure
    node_added: has_node (Result)
    count_increased: node_count = old node_count + 1
    model_extended: model_nodes |=| (old model_nodes & Result)
    edges_unchanged: model_edges |=| old model_edges
```

#### add_node_with_id (a_id: INTEGER; a_data: G)
```eiffel
require
    id_positive: a_id > 0
    no_existing: not has_node (a_id)
ensure
    node_added: has_node (a_id)
    count_increased: node_count = old node_count + 1
    model_extended: model_nodes |=| (old model_nodes & a_id)
    edges_unchanged: model_edges |=| old model_edges
```

#### remove_node (a_id: INTEGER)
```eiffel
require
    has_node: has_node (a_id)
ensure
    node_removed: not has_node (a_id)
    count_decreased: node_count = old node_count - 1
    model_reduced: model_nodes |=| (old model_nodes / a_id)
    no_edges_involving_node: not model_edges.domain [a_id] and not model_edges.range [a_id]
```

### Edge Operation Contracts

#### add_edge (a_from, a_to: INTEGER)
```eiffel
require
    from_exists: has_node (a_from)
    to_exists: has_node (a_to)
ensure
    edge_exists: has_edge (a_from, a_to)
    nodes_unchanged: model_nodes |=| old model_nodes
```

#### add_edge_weighted (a_from, a_to: INTEGER; a_weight: REAL_64)
```eiffel
require
    from_exists: has_node (a_from)
    to_exists: has_node (a_to)
ensure
    edge_exists: has_edge (a_from, a_to)
    reverse_for_undirected: not is_directed and a_from /= a_to implies has_edge (a_to, a_from)
    nodes_unchanged: model_nodes |=| old model_nodes
```

#### remove_edge (a_from, a_to: INTEGER)
```eiffel
require
    has_edge: has_edge (a_from, a_to)
ensure
    edge_removed: not has_edge (a_from, a_to)
    nodes_unchanged: model_nodes |=| old model_nodes
```

### Query Contracts

#### node (a_id: INTEGER): detachable G
```eiffel
require
    has_node: has_node (a_id)
```

#### neighbors (a_id: INTEGER): ARRAYED_LIST [INTEGER]
```eiffel
require
    has_node: has_node (a_id)
ensure
    all_neighbors_are_nodes: across Result as ic all has_node (ic) end
```

#### edge_weight (a_from, a_to: INTEGER): REAL_64
```eiffel
require
    has_edge: has_edge (a_from, a_to)
```

#### degree (a_id: INTEGER): INTEGER
```eiffel
require
    has_node: has_node (a_id)
```

#### in_degree (a_id: INTEGER): INTEGER
```eiffel
require
    has_node: has_node (a_id)
```

#### out_degree (a_id: INTEGER): INTEGER
```eiffel
require
    has_node: has_node (a_id)
```

### Traversal Contracts

#### bfs (a_start: INTEGER): ARRAYED_LIST [INTEGER]
```eiffel
require
    has_node: has_node (a_start)
ensure
    starts_with_start: not Result.is_empty implies Result.first = a_start
```

#### dfs (a_start: INTEGER): ARRAYED_LIST [INTEGER]
```eiffel
require
    has_node: has_node (a_start)
ensure
    starts_with_start: not Result.is_empty implies Result.first = a_start
```

### Shortest Path Contracts

#### dijkstra (a_start, a_end: INTEGER): ARRAYED_LIST [INTEGER]
```eiffel
require
    start_exists: has_node (a_start)
    end_exists: has_node (a_end)
ensure
    empty_or_starts_at_start: Result.is_empty or else Result.first = a_start
    empty_or_ends_at_end: Result.is_empty or else Result.last = a_end
```

#### shortest_distance (a_start, a_end: INTEGER): REAL_64
```eiffel
require
    start_exists: has_node (a_start)
    end_exists: has_node (a_end)
```

### Analysis Contracts

#### topological_sort: ARRAYED_LIST [INTEGER]
```eiffel
require
    directed: is_directed
ensure
    empty_if_cycle: has_cycle implies Result.is_empty
```

### Clear Contract

#### clear
```eiffel
ensure
    empty: is_empty
    model_nodes_empty: model_nodes.is_empty
    model_edges_empty: model_edges.is_empty
```

### Model Query Contracts

#### model_nodes: MML_SET [INTEGER]
```eiffel
ensure
    count_matches: Result.count = node_count
    all_valid: Result.for_all (agent has_node)
```

#### model_edges: MML_RELATION [INTEGER, INTEGER]
```eiffel
ensure
    count_matches: Result.count = edge_count
```

#### model_adjacency: MML_MAP [INTEGER, MML_SET [INTEGER]]
```eiffel
ensure
    domain_matches: Result.domain |=| model_nodes
```

## SIMPLE_GRAPH_EDGE Contracts

### Creation Contracts

#### make (a_to: INTEGER; a_weight: REAL_64)
```eiffel
require
    valid_to: a_to > 0
ensure
    to_set: to_node = a_to
    weight_set: weight = a_weight
```

#### make_unweighted (a_to: INTEGER)
```eiffel
require
    valid_to: a_to > 0
ensure
    to_set: to_node = a_to
    default_weight: weight = 1.0
```

## Class Invariants

### SIMPLE_GRAPH
```eiffel
invariant
    valid_next_id: next_id >= 1
    edges_valid: model_edges.domain <= model_nodes and model_edges.range <= model_nodes
    adjacency_consistent: model_adjacency.domain |=| model_nodes
```

### SIMPLE_GRAPH_EDGE
```eiffel
invariant
    valid_to_node: to_node > 0
```

## Model Query Semantics

### model_nodes: MML_SET [INTEGER]
Returns the set of all node IDs currently in the graph.

### model_edges: MML_RELATION [INTEGER, INTEGER]
Returns the relation of edge pairs. For undirected graphs, each edge appears once with the lower ID first.

### model_adjacency: MML_MAP [INTEGER, MML_SET [INTEGER]]
Maps each node to its set of neighbor node IDs.
