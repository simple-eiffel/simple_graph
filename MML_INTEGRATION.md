# MML Integration - simple_graph

## Overview
Applied X03 Contract Assault with simple_mml on 2025-01-21.

## MML Classes Used
- `MML_SET [INTEGER]` - Models set of node IDs in the graph
- `MML_RELATION [INTEGER, INTEGER]` - Models edge pairs (from_node, to_node)
- `MML_MAP [INTEGER, MML_SET [INTEGER]]` - Models adjacency list (node to neighbors)

## Model Queries Added
- `model_nodes: MML_SET [INTEGER]` - Set of all node IDs in the graph
- `model_edges: MML_RELATION [INTEGER, INTEGER]` - Relation of edge pairs
- `model_adjacency: MML_MAP [INTEGER, MML_SET [INTEGER]]` - Map from node to neighbor set

## Model-Based Postconditions
| Feature | Postcondition | Purpose |
|---------|---------------|---------|
| `model_nodes` | `count_matches: Result.count = node_count`, `all_valid: Result.for_all (agent has_node)` | Model consistent with state |
| `model_edges` | `count_matches: Result.count = edge_count` | Edge count matches |
| `model_adjacency` | `domain_matches: Result.domain \|=\| model_nodes` | Every node has adjacency entry |
| `add_node` | `model_extended: model_nodes \|=\| (old model_nodes & Result)`, `edges_unchanged: model_edges \|=\| old model_edges` | Node added preserves edges |
| `add_node_with_id` | `model_extended: model_nodes \|=\| (old model_nodes & a_id)` | Specific ID added to model |
| `add_edge` | `nodes_unchanged: model_nodes \|=\| old model_nodes` | Edge add preserves nodes |
| `add_edge_weighted` | `nodes_unchanged: model_nodes \|=\| old model_nodes` | Weighted edge preserves nodes |
| `remove_node` | `model_reduced: model_nodes \|=\| (old model_nodes / a_id)`, `no_edges_involving_node: not model_edges.domain [a_id] and not model_edges.range [a_id]` | Node removal cleans up edges |
| `remove_edge` | `nodes_unchanged: model_nodes \|=\| old model_nodes` | Edge removal preserves nodes |
| `clear` | `model_nodes_empty: model_nodes.is_empty`, `model_edges_empty: model_edges.is_empty` | Clear empties model |

## Invariants Added
- `edges_valid: model_edges.domain <= model_nodes and model_edges.range <= model_nodes` - Edges only connect existing nodes
- `adjacency_consistent: model_adjacency.domain |=| model_nodes` - Every node has adjacency entry

## Bugs Found
None

## Test Results
- Compilation: SUCCESS
- Tests: All PASS
