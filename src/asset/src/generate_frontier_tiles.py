#!/usr/bin/env python3
import xml.etree.ElementTree as XML
import sys
import os

SVG_PREFIX = "{http://www.w3.org/2000/svg}"
G_TAG = SVG_PREFIX + "g"
TEMPLATE_PREFIX = "rtid-"
################################################################################
def id_to_prefix (id_val):
    return ("rmid-" + id_val + "-")

def get_xml (filename):
    model_root = XML.parse(filename)

    if (model_root == None):
        print("[F] Could not open SVG file " + filename + ".")
        exit(-1)

    return model_root

def get_model (filename, id_prefix):
    model_root = get_xml(filename)

    background = model_root.findall(
        G_TAG
        + "[@id='"
        + id_prefix
        + "background']/*"
    )

    if (len(background) == 0):
        print(
            "[F] Could not find 'background' layer in model file ("
            + filename
            + ")"
        )
        exit(-1)

    extras = model_root.findall(
        G_TAG
        + "[@id='"
        + id_prefix
        + "details']/*"
    )

    if (len(extras) == 0):
        if (model_root.find(G_TAG+"[@id='" + id_prefix + "details']") == None):
            print(
                "[W] Could not find 'details' layer in model file ("
                + filename
                + ")"
            )

    return (background, extras)

def replace_group_by (root_node, group_name, new_content, filename):
    target_group = root_node.find(G_TAG+"[@id='" + group_name + "']")

    if (target_group == None):
        print("[F] Could not find group " + group_name + " in " + filename)
        exit(-1)

    for e in target_group:
        target_group.remove(e)

    target_group.extend(new_content)
################################################################################

if (len(sys.argv) < 6):
    print("Usage: <OUTPUT_DIR> <A_ID> <B_ID> <A> <B> <TEMPLATES>")
    exit(-1)

output_dir = sys.argv[1]
model_a_id = sys.argv[2]
model_b_id = sys.argv[3]
(model_a_bg, model_a_details) = get_model(sys.argv[4], id_to_prefix(model_a_id))
(model_b_bg, model_b_details) = get_model(sys.argv[5], id_to_prefix(model_b_id))

current_arg = 6
variant_count = 0

while (current_arg < len(sys.argv)):
    filename = sys.argv[current_arg]
    current_arg += 1

    template_root = get_xml(filename)

    models_layer = template_root.find(
        G_TAG
        + "[@id='"
        + TEMPLATE_PREFIX
        + "models_layer']"
    )

    if (models_layer == None):
        print("[F] Could not find model layer in file " + filename + ".")

    replace_group_by(models_layer, TEMPLATE_PREFIX + "bg_a_model", model_a_bg, filename)
    replace_group_by(models_layer, TEMPLATE_PREFIX + "bg_b_model", model_b_bg, filename)
    replace_group_by(template_root, TEMPLATE_PREFIX + "details", model_a_details, filename)

    template_root.write(
        output_dir
        + "/"
        + model_a_id
        + "-"
        + model_b_id
        + "-"
        + os.path.basename(filename)
    )

    variant_count += 1
