#!/usr/bin/env python3
import os
import shutil
import sys
import xml.etree.ElementTree as XML

SVG_PREFIX = "{http://www.w3.org/2000/svg}"
G_TAG = SVG_PREFIX + "g"

MODEL_PREFIX = "rmid-"
TEMPLATE_PREFIX = "rtid-"

################################################################################

def get_xml (filename):
    model_root = XML.parse(filename)

    if (model_root == None):
        print("[F] Could not open SVG file " + filename + ".")
        exit(-1)

    return model_root

def get_model (filename):
    model_root = get_xml(filename)

    background = model_root.findall(
        G_TAG
        + "[@id='"
        + MODEL_PREFIX
        + "background']/*"
    )

    if (len(background) == 0):
        print(
            "[F] Could not find 'background' layer in model file ("
            + filename
            + ")"
        )
        exit(-1)

    return background

def replace_group_by (root_node, group_name, new_content, filename):
    target_group = root_node.find(G_TAG+"[@id='" + group_name + "']")

    if (target_group == None):
        print("[F] Could not find group " + group_name + " in " + filename)
        exit(-1)

    for e in target_group:
        target_group.remove(e)

    target_group.extend(new_content)

def generate_background_file (output_dir, bg_file, tile_class):
    shutil.copyfile(
        bg_file,
        (output_dir + "/" + tile_class + "-bg.svg")
    )

def generate_variant_file (output_dir, variant_file, tile_class):
    shutil.copyfile(
        variant_file,
        (
            output_dir
            + "/"
            + tile_class
            + "-v-"
            + os.path.basename(variant_file)
        )
    )

def generate_frontier_file (output_dir, tile_class, bg_content, frontier_file):
    template_root = get_xml(frontier_file)

    models_layer = template_root.find(
        G_TAG
        + "[@id='"
        + TEMPLATE_PREFIX
        + "models_layer']"
    )

    if (models_layer == None):
        print("[F] Could not find model layer in file " + frontier_file + ".")
        exit(-1)

    replace_group_by(
        models_layer,
        (TEMPLATE_PREFIX + "bg_b_model"),
        bg_content,
        frontier_file
    )

    template_root.write(
        output_dir
        + "/"
        + tile_class
        + "-f-"
        + os.path.basename(frontier_file)
    )


################################################################################

if (len(sys.argv) != 4):
    print("Usage: <OUTPUT_DIR> <CLASSES_DIR> <TEMPLATES_DIR>")
    exit(-1)

output_dir = sys.argv[1]
classes_dir = sys.argv[2]
templates_dir = sys.argv[3]

class_dirs = os.listdir(classes_dir)
template_files = os.listdir(templates_dir)
template_files_list = " ".join(
    [(templates_dir + "/" + e) for e in template_files]
)

for tile_class in class_dirs:
    print("Generating SVG files for tile class " + tile_class + "...")
    tile_class_dir = classes_dir + "/" + tile_class
    background_file = tile_class_dir + "/background.svg"
    background_content = get_model(background_file)

    generate_background_file(output_dir, background_file, tile_class)

    ### Frontier files
    for frontier_class in template_files:
        frontier_file = templates_dir + "/" + frontier_class
        generate_frontier_file(
            output_dir,
            tile_class,
            background_content,
            frontier_file
        )

    ### Tile Variations
    tile_variants = os.listdir(tile_class_dir)

    for tile_variant in tile_variants:
        if ("background" in tile_variant):
            continue

        tile_variant_file = tile_class_dir + "/" + tile_variant
        generate_variant_file(output_dir, tile_variant_file, tile_class)

