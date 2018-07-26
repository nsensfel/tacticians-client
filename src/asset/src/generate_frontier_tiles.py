#!/usr/bin/env python3
import xml.etree.ElementTree as XML
import sys

SVG_PREFIX = "{http://www.w3.org/2000/svg}"
G_TAG = SVG_PREFIX + "g"

################################################################################
def get_xml (filename):
    model_root = XML.parse(filename)

    if (model_root == None):
        print("Could not open SVG file " + filename + ".")
        exit(-1)

    return model_root

def get_model (filename):
    model_root = get_xml(filename)

    result = model_root.findall(G_TAG+"[1]/*")

    if (len(result) == 0):
        print("Could not find content in model file (" + filename + ")")
        exit(-1)

    return result

def replace_group_by (root_node, group_name, new_content, filename):
    target_group = root_node.find(G_TAG+"[@id='" + group_name + "']")

    if (target_group == None):
        print("Could not find group " + group_name + " in " + filename)
        exit(-1)

    for e in target_group:
        target_group.remove(e)

    target_group.extend(new_content)
################################################################################

if (len(sys.argv) < 3):
    print("Usage: <A> <B> <TEMPLATES>")
    exit(-1)

model_a = get_model(sys.argv[1])
model_b = get_model(sys.argv[2])

if ((model_b == None) or (len(model_b) == 0)):
    print("Could not find content in model B (" + sys.argv[2] + ")")
    exit(-1)

current_arg = 3

while (current_arg < len(sys.argv)):
    filename = sys.argv[current_arg]
    current_arg += 1

    template_root = get_xml(filename)

    models_layer = template_root.find(G_TAG+"[@id='models_layer']")

    if (models_layer == None):
        print("Could not find model layer in file " + filename + ".")

    replace_group_by(models_layer, "bg_a_model", model_a, filename)
    replace_group_by(models_layer, "bg_b_model", model_b, filename)

    template_root.write("/tmp/test" + str(current_arg) + ".svg")
