#!/usr/bin/env python3
import xml.etree.ElementTree as XML
import sys
import bisect

################################################################################
def get_xml (filename):
    model_root = XML.parse(filename)

    if (model_root == None):
        print("[F] Could not open SVG file " + filename + ".")
        exit(-1)

    return model_root

def get_relevant_ids (root_node, prefix):
    result = []

    elements_having_an_id = root_node.findall("//*[@id]")

    for e in elements_having_an_id:
        e_id = e.get("id")

        if (not e_id.startswith(prefix)):
            bisect.insort(result, e_id)

    result.reverse()

    return result

def replace_string_in_all_attributes_by (node, current_str, new_str):
    for (a_name, a_val) in node.items():
        node.set(a_name, a_val.replace(current_str, new_str))

def add_prefix_to_ids_in_xml_element (node, ids, prefix):
    for id_val in ids:
        replace_string_in_all_attributes_by(node, id_val, (prefix + id_val))

################################################################################
arg_len = len(sys.argv)

if (arg_len < 3):
    print("Usage: <PREFIX> <SVG FILES>")
    exit(-1)

current_arg = 2
PREFIX = sys.argv[1]

while (current_arg < arg_len):
    svg_root = get_xml(sys.argv[current_arg])
    relevant_ids = get_relevant_ids(svg_root, PREFIX)

    for e in svg_root.findall("//*"):
        add_prefix_to_ids_in_xml_element(e, relevant_ids, PREFIX)

    svg_root.write(sys.argv[current_arg])

    current_arg += 1
