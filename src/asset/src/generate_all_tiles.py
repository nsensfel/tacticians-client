#!/usr/bin/env python3
import sys
import os
import shutil

################################################################################

################################################################################

if (len(sys.argv) != 5):
    print("Usage: <OUTPUT_DIR> <CLASSES_DIR> <TEMPLATES_DIR> <FRONTIER_SCRIPT>")
    exit(-1)

output_dir = sys.argv[1]
classes_dir = sys.argv[2]
templates_dir = sys.argv[3]
frontier_script = sys.argv[4]

class_dirs = os.listdir(classes_dir)
template_files = os.listdir(templates_dir)
template_files_list = " ".join([ (templates_dir + "/" + e) for e in template_files])

for a_model in class_dirs:
    a_model = classes_dir + a_model
    print("A Model: " + a_model)
    a_model_id = os.path.basename(a_model)
    base_prefix = output_dir + "/" + a_model_id + "-"

    for b_model in class_dirs:
        b_model = classes_dir + b_model
        b_model_id = os.path.basename(b_model)
        prefix = base_prefix + b_model_id + "-"

        if (a_model_id == b_model_id):
            for variation in os.listdir(a_model):
                print("---")
                print("Variation: " + variation)
                print("a_model: " + a_model)
                print("prefix: " + prefix)
                print("---")
                shutil.copyfile(
                    a_model + "/" + variation,
                    prefix + variation
                )
        else:
            os.system(
                frontier_script
                + " " + output_dir
                + " " + a_model_id
                + " " + b_model_id
                + " " + a_model + "/0.svg"
                + " " + b_model + "/0.svg"
                + " " + template_files_list
            )

