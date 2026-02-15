import sys
import re
import os

def parse_tscn(filepath):
    with open(filepath, 'r') as f:
        lines = f.readlines()

    resources = {} # id -> path
    nodes = [] # list of dicts: {name, type, parent, ...}

    current_section = None
    current_node = None

    # Regex for [ext_resource ...]
    # [ext_resource type="Script" path="res://main.gd" id="2_fghij"]
    ext_res_pattern = re.compile(r'\[ext_resource\s+.*?path="([^"]+)".*?id="?([^"]+)"?.*\]')

    # Regex for [node ...]
    # [node name="Main" type="Node2D"]
    # [node name="Sprite2D" type="Sprite2D" parent="."]
    node_pattern = re.compile(r'\[node\s+name="([^"]+)"\s+type="([^"]+)"(?:\s+parent="([^"]+)")?.*\]')

    for line in lines:
        line = line.strip()
        if not line: continue

        # Check for external resources
        m_res = ext_res_pattern.match(line)
        if m_res:
            path = m_res.group(1)
            rid = m_res.group(2)
            # type might be useful too
            type_match = re.search(r'type="([^"]+)"', line)
            rtype = type_match.group(1) if type_match else "Resource"
            resources[rid] = {'path': path, 'type': rtype}
            continue

        # Check for nodes
        m_node = node_pattern.match(line)
        if m_node:
            name = m_node.group(1)
            ntype = m_node.group(2)
            parent = m_node.group(3)

            # Parent "." means root of the scene (but usually root node has no parent attr in tscn)
            # If parent is None, it's the root node (unless it's a sub-scene instance, handled differently)
            if parent is None:
                parent = "."
            elif parent == ".":
                # It is a child of the root node
                # We need to identify the root node name to reconstruct path
                pass

            current_node = {
                'name': name,
                'type': ntype,
                'parent': parent,
                'script': None,
                'children': []
            }
            nodes.append(current_node)
            continue

        # Check for script attachment
        # script = ExtResource("2_fghij")
        if current_node and line.startswith("script = ExtResource"):
             # extract ID
             m_script = re.search(r'ExtResource\("?([^"]+)"?\)', line)
             if m_script:
                 rid = m_script.group(1)
                 if rid in resources:
                     current_node['script'] = resources[rid]['path']

    return resources, nodes

def build_tree(nodes):
    # Map name -> node
    # But names are only unique within siblings.
    # Also parent references are paths like "." or "Player" or "Player/Sprite"

    # First find root
    # Root node in tscn usually has parent="." implicitly or just no parent attribute?
    # Actually, the *first* node declared is the root. It has no 'parent' attribute.
    if not nodes:
        return None

    root = nodes[0] # The first one is invariably the root
    # Initialize children list for all
    for n in nodes:
        n['children'] = []

    # We need a way to look up nodes by path
    # Parent "." refers to root.
    # Parent "NodeName" refers to direct child of root? No, parent matches the path relative to root?
    # In .tscn, parent is a path relative to the scene root?
    # If parent is ".", it means child of root.
    # If parent is "Path/To/Node", it means child of that node.

    # Store nodes by path?
    # Path of root is "."
    node_map = {".": root}

    # We iterate and assign children
    # Since nodes are usually ordered parent-first, we might find parent in node_map

    for n in nodes[1:]: # Skip root
        parent_path = n['parent']
        # If parent_path is ".", parent is root
        if parent_path == ".":
             root['children'].append(n)
             # Add to map. access path will be just name (relative to root)?
             # Wait, in tscn parent="." means direct child of root.
             node_map[n['name']] = n
        else:
             # parent_path might be "ParentNode" or "Parent/Child"
             if parent_path in node_map:
                 node_map[parent_path]['children'].append(n)
                 # Add self to map
                 my_path = f"{parent_path}/{n['name']}"
                 node_map[my_path] = n
             else:
                 # Parent not found yet? Should not happen in standard tscn unless disordered
                 # fallback
                 pass

    return root

def print_tree(node, depth=0):
    indent = "  " * depth
    script_info = f" script={node['script']}" if node['script'] else ""
    print(f"{indent}{node['name']} ({node['type']}){script_info}")
    for child in node['children']:
        print_tree(child, depth + 1)

def main():
    if len(sys.argv) < 2:
        print("Usage: inspect_scene.py [path_to_tscn]")
        sys.exit(1)

    path = sys.argv[1]

    # Resolve res://
    if path.startswith("res://"):
        path = path.replace("res://", "")
        # assume running from project root

    if not os.path.exists(path):
        # Try finding it
        if os.path.exists(f"godot-gemini-plugin/{path}"):
            path = f"godot-gemini-plugin/{path}"
        elif os.path.exists(f"../{path}"):
             path = f"../{path}"

    if not os.path.exists(path):
         print(f"Error: File {path} not found.")
         sys.exit(1)

    resources, nodes = parse_tscn(path)

    print("Resources:")
    for rid, info in resources.items():
        print(f"[{rid}] {info['path']} ({info['type']})")
    print("\nNodes:")

    root = build_tree(nodes)
    if root:
        print_tree(root)
    else:
        print("No nodes found.")

if __name__ == "__main__":
    main()
