#!/usr/bin/env python3
"""
Godot Scene Builder - Generates valid .tscn files programmatically.

Usage:
  python3 build_scene.py \
    --output "path/to/scene.tscn" \
    --root "RootName:NodeType" \
    --nodes "Name:Type:Parent" "Name2:Type2:Parent2" \
    --scripts "NodeName=res://script.gd" \
    --resources "NodeName.property=res://resource.tres:ResourceType" \
    --subresources "SubResType:prop1=val1,prop2=val2" \
    --connections "FromNode:signal_name:ToNode:method_name"
"""

import argparse
import os
import sys
import random
import string


def generate_id(prefix=""):
    """Generate a unique resource ID like '1_abcde'."""
    suffix = ''.join(random.choices(string.ascii_lowercase, k=5))
    return f"{prefix}_{suffix}" if prefix else suffix


def parse_node_spec(spec):
    """Parse 'Name:Type:Parent' into a dict."""
    parts = spec.split(":")
    if len(parts) < 2:
        print(f"Error: Invalid node spec '{spec}'. Expected 'Name:Type' or 'Name:Type:Parent'.")
        sys.exit(1)
    return {
        'name': parts[0],
        'type': parts[1],
        'parent': parts[2] if len(parts) > 2 else None
    }


def parse_script_spec(spec):
    """Parse 'NodeName=res://path.gd' into a tuple."""
    parts = spec.split("=", 1)
    if len(parts) != 2:
        print(f"Error: Invalid script spec '{spec}'. Expected 'NodeName=res://path.gd'.")
        sys.exit(1)
    return parts[0], parts[1]


def parse_connection_spec(spec):
    """Parse 'FromNode:signal:ToNode:method' into a dict."""
    parts = spec.split(":")
    if len(parts) != 4:
        print(f"Error: Invalid connection spec '{spec}'. Expected 'From:signal:To:method'.")
        sys.exit(1)
    return {
        'from': parts[0],
        'signal': parts[1],
        'to': parts[2],
        'method': parts[3]
    }


def parse_subresource_spec(spec):
    """Parse 'Type:prop1=val1,prop2=val2' into a dict."""
    parts = spec.split(":", 1)
    rtype = parts[0]
    props = {}
    if len(parts) > 1 and parts[1]:
        for pair in parts[1].split(","):
            k, v = pair.split("=", 1)
            props[k.strip()] = v.strip()
    return {'type': rtype, 'properties': props}


def build_tscn(root_spec, node_specs, script_map, connections, subresource_specs):
    """Build the .tscn file content."""
    lines = []

    # Collect external resources
    ext_resources = []
    ext_id_counter = 1
    script_ext_ids = {}  # node_name -> ext_resource_id

    for node_name, script_path in script_map.items():
        rid = generate_id(str(ext_id_counter))
        ext_resources.append({
            'type': 'Script',
            'path': script_path,
            'id': rid
        })
        script_ext_ids[node_name] = rid
        ext_id_counter += 1

    # Collect sub-resources
    sub_resources = []
    sub_id_counter = 1
    for spec in subresource_specs:
        parsed = parse_subresource_spec(spec)
        sid = f"sub_{sub_id_counter}"
        parsed['id'] = sid
        sub_resources.append(parsed)
        sub_id_counter += 1

    # Calculate load_steps
    load_steps = len(ext_resources) + len(sub_resources) + 1

    # Header
    lines.append(f'[gd_scene load_steps={load_steps} format=3]')
    lines.append('')

    # External resources
    for ext in ext_resources:
        lines.append(f'[ext_resource type="{ext["type"]}" path="{ext["path"]}" id="{ext["id"]}"]')
    if ext_resources:
        lines.append('')

    # Sub-resources
    for sub in sub_resources:
        lines.append(f'[sub_resource type="{sub["type"]}" id="{sub["id"]}"]')
        for k, v in sub['properties'].items():
            lines.append(f'{k} = {v}')
        lines.append('')

    # Root node
    root = parse_node_spec(root_spec)
    root_line = f'[node name="{root["name"]}" type="{root["type"]}"]'
    lines.append(root_line)
    if root['name'] in script_ext_ids:
        lines.append(f'script = ExtResource("{script_ext_ids[root["name"]]}")')
    lines.append('')

    # Child nodes
    for spec in node_specs:
        node = parse_node_spec(spec)
        parent = node['parent'] if node['parent'] else '.'
        node_line = f'[node name="{node["name"]}" type="{node["type"]}" parent="{parent}"]'
        lines.append(node_line)
        if node['name'] in script_ext_ids:
            lines.append(f'script = ExtResource("{script_ext_ids[node["name"]]}")')
        lines.append('')

    # Connections
    for spec in connections:
        conn = parse_connection_spec(spec)
        # Resolve "to" path: if it's the root node name, use "."
        to_path = conn['to']
        if to_path == root['name']:
            to_path = '.'
        from_path = conn['from']
        if from_path == root['name']:
            from_path = '.'

        lines.append(f'[connection signal="{conn["signal"]}" from="{from_path}" to="{to_path}" method="{conn["method"]}"]')

    return '\n'.join(lines) + '\n'


def main():
    parser = argparse.ArgumentParser(description='Generate a Godot .tscn scene file.')
    parser.add_argument('--output', required=True, help='Output path for the .tscn file')
    parser.add_argument('--root', required=True, help='Root node as "Name:Type"')
    parser.add_argument('--nodes', nargs='*', default=[], help='Child nodes as "Name:Type:Parent"')
    parser.add_argument('--scripts', nargs='*', default=[], help='Script attachments as "NodeName=res://path.gd"')
    parser.add_argument('--subresources', nargs='*', default=[], help='Sub-resources as "Type:prop=val,prop2=val2"')
    parser.add_argument('--connections', nargs='*', default=[], help='Signal connections as "From:signal:To:method"')

    args = parser.parse_args()

    # Parse scripts
    script_map = {}
    for s in args.scripts:
        node_name, path = parse_script_spec(s)
        script_map[node_name] = path

    # Build
    content = build_tscn(args.root, args.nodes, script_map, args.connections, args.subresources)

    # Resolve output path
    output_path = args.output
    if output_path.startswith("res://"):
        output_path = output_path.replace("res://", "")
        # Try to find the project root
        if os.path.exists("project.godot"):
            pass  # Already in project root
        elif os.path.exists("godot-gemini-plugin/project.godot"):
            output_path = os.path.join("godot-gemini-plugin", output_path)

    # Ensure parent directory exists
    os.makedirs(os.path.dirname(output_path) if os.path.dirname(output_path) else '.', exist_ok=True)

    with open(output_path, 'w') as f:
        f.write(content)

    print(f"Scene written to: {output_path}")
    print(f"  Root: {args.root}")
    print(f"  Nodes: {len(args.nodes)}")
    print(f"  Scripts: {len(script_map)}")
    print(f"  Connections: {len(args.connections)}")


if __name__ == "__main__":
    main()
