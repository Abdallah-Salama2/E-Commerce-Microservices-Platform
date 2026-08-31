export function buildCategoryTree(flatRows) {
  const nodeMap = new Map();

  // Pass 1: create every node once, attach an empty children array,
  // and index it by id so we can look it up in O(1) later.
  for (const row of flatRows) {
    nodeMap.set(row.id, { ...row, children: [] });
  }

  const tree = [];

  // Pass 2: walk the rows again, and place each node under its parent
  // (or into the root array if it has no parent).
  for (const row of flatRows) {
    const node = nodeMap.get(row.id);

    if (row.parentCategoryId === null) {
      tree.push(node);
    } else {
      const parentNode = nodeMap.get(row.parentCategoryId);
      if (parentNode) {
        parentNode.children.push(node);
      }
      // if parentNode is missing (orphaned row — shouldn't happen given the FK,
      // but defensive coding matters), we silently skip rather than crash
    }
  }

  return tree;
}
