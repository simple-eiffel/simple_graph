# S01 - Project Inventory

**Library:** simple_graph
**Version:** 1.0.0
**Status:** BACKWASH (reverse-engineered from implementation)
**Generated:** 2026-01-23

## Overview

simple_graph provides a generic graph data structure with adjacency list representation. It supports both directed and undirected graphs with weighted edges, and includes standard graph algorithms (BFS, DFS, Dijkstra, topological sort, cycle detection).

## Project Files

### Source Files (src/)

| File | Class | Description | LOC |
|------|-------|-------------|-----|
| simple_graph.e | SIMPLE_GRAPH [G] | Main generic graph class | ~890 |
| simple_graph_edge.e | SIMPLE_GRAPH_EDGE | Edge with target node and weight | ~77 |

### Test Files (testing/)

| File | Description |
|------|-------------|
| test_app.e | Main test application entry point |
| lib_tests.e | Library test suite |

### Research Files (research/)

| File | Description |
|------|-------------|
| SIMPLE_GRAPH_RESEARCH.md | 7-step research process documentation |

### Configuration Files

| File | Description |
|------|-------------|
| simple_graph.ecf | ECF configuration |

## Dependencies

### ISE Libraries
- `$ISE_LIBRARY/library/base/base.ecf` - Base library (HASH_TABLE, ARRAYED_LIST, etc.)

### MML (Mathematical Model Library)
- MML_SET - For model_nodes
- MML_RELATION - For model_edges
- MML_MAP - For model_adjacency

## Key Statistics

- **Total Source LOC:** ~967
- **Number of Classes:** 2
- **Number of Features (SIMPLE_GRAPH):** ~45
- **Number of Features (SIMPLE_GRAPH_EDGE):** ~7
- **Generic Parameter:** G -> detachable separate ANY (void-safe, SCOOP-ready)
- **Graph Algorithms:** 5 (BFS, DFS, Dijkstra, topological_sort, cycle detection)

## Phase Status

- Phase 1: Core functionality - COMPLETE
- Phase 2: Expanded features - COMPLETE
- Phase 3: Performance optimization - NOT STARTED
- Phase 4: API documentation - IN PROGRESS
- Phase 5: Test coverage - PARTIAL
- Phase 6: Production hardening - NOT STARTED
