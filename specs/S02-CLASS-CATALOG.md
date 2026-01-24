# S02 - Class Catalog

**Library:** simple_graph
**Status:** BACKWASH (reverse-engineered from implementation)
**Generated:** 2026-01-23

## Class Hierarchy

```
ANY
 +-- SIMPLE_GRAPH [G -> detachable separate ANY]    [Main graph class]
 +-- SIMPLE_GRAPH_EDGE                               [Edge representation]
```

## Class Details

### SIMPLE_GRAPH [G -> detachable separate ANY]

**Purpose:** Generic graph data structure with adjacency list representation.

**Generic Parameter:**
- G: Node data type, constrained to `detachable separate ANY` for void safety and SCOOP compatibility

**Responsibilities:**
- Node management (add, remove, query)
- Edge management (add, remove, query)
- Graph traversal (BFS, DFS)
- Shortest path computation (Dijkstra)
- Graph analysis (connectivity, cycles, topological sort)
- Model queries for contract specification

**Creation Procedures:**
- `make` - Create undirected graph
- `make_directed` - Create directed graph

**Invariants:**
```eiffel
valid_next_id: next_id >= 1
edges_valid: model_edges.domain <= model_nodes and model_edges.range <= model_nodes
adjacency_consistent: model_adjacency.domain |=| model_nodes
```

**Internal Representation:**
- `nodes: HASH_TABLE [G, INTEGER]` - Node data by ID
- `adjacency: HASH_TABLE [ARRAYED_LIST [SIMPLE_GRAPH_EDGE], INTEGER]` - Adjacency lists

**Collaborators:**
- SIMPLE_GRAPH_EDGE (composition for edge storage)
- ARRAYED_QUEUE (BFS algorithm)
- ARRAYED_STACK (DFS algorithm)
- HASH_TABLE (node storage, visited tracking)

---

### SIMPLE_GRAPH_EDGE

**Purpose:** Represents an edge with target node and optional weight.

**Responsibilities:**
- Store edge destination node ID
- Store edge weight (default 1.0)
- Provide edge comparison

**Creation Procedures:**
- `make (a_to: INTEGER; a_weight: REAL_64)` - Create weighted edge
- `make_unweighted (a_to: INTEGER)` - Create edge with weight 1.0

**Invariants:**
```eiffel
valid_to_node: to_node > 0
```

**Collaborators:**
- SIMPLE_GRAPH (contained by)

## Design Patterns

### Adjacency List Pattern
Graph representation using lists of edges per node, optimal for sparse graphs.
- Space: O(V + E)
- Edge lookup: O(degree)
- Neighbor iteration: O(degree)

### Integer Node IDs
Nodes identified by sequential integers rather than object references:
- Stable references across mutations
- O(1) lookup via hash table
- Avoids object identity confusion (NetworkX pain point)

### Generic Node Data
Node data stored separately from graph structure:
- Any Eiffel type as node payload
- Type-safe access
- Decoupled data from topology

### Model-Based Specification
MML (Mathematical Model Library) queries for contract verification:
- model_nodes: MML_SET [INTEGER]
- model_edges: MML_RELATION [INTEGER, INTEGER]
- model_adjacency: MML_MAP [INTEGER, MML_SET [INTEGER]]
