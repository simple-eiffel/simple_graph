# Drift Analysis: simple_graph

Generated: 2026-01-24
Method: `ec.exe -flatshort` vs `specs/*.md` + `research/*.md`

## Specification Sources

| Source | Files | Lines |
|--------|-------|-------|
| specs/*.md | 8 | 1183 |
| research/*.md | 1 | 336 |

## Classes Analyzed

| Class | Spec'd Features | Actual Features | Drift |
|-------|-----------------|-----------------|-------|
| SIMPLE_GRAPH | 10 | 53 | +43 |

## Feature-Level Drift

### Specified, Implemented ✓
- `edge_count` ✓
- `has_cycle` ✓
- `has_edge` ✓
- `is_connected` ✓
- `make_directed` ✓
- `topological_sort` ✓

### Specified, NOT Implemented ✗
- `connected_components` ✗
- `new_directed_graph` ✗
- `new_graph` ✗
- `new_string_graph` ✗

### Implemented, NOT Specified
- `Io`
- `Operating_environment`
- `add_edge`
- `add_edge_weighted`
- `add_node`
- `add_node_with_id`
- `adjacency_consistent`
- `all_edges`
- `all_nodes`
- `author`
- ... and 37 more

## Summary

| Category | Count |
|----------|-------|
| Spec'd, implemented | 6 |
| Spec'd, missing | 4 |
| Implemented, not spec'd | 47 |
| **Overall Drift** | **HIGH** |

## Conclusion

**simple_graph** has high drift. Significant gaps between spec and implementation.
