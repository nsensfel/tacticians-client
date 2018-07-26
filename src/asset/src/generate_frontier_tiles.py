#!/usr/bin/env python3
import xml.etree.ElementTree as XML
import sys

if (len(sys.argv) < 3):
    print("Usage: <A> <B> <TEMPLATES>")
    exit(-1)

model_a = XML.parse(sys.argv[1]).findall("./svg/g[1]/*")
model_b = XML.parse(sys.argv[2]).findall("./svg/g[1]/*")
current_arg = 3

while (current_arg <= 3):
    template_root = XML.parse(sys.argv[current_arg])
    current_arg += 1
    template_model_a = template_root.find("./svg/g[id='models_layer']/g[id='bg_a_model']")
    template_model_b = template_root.find("/svg/g[id='models_layer']/g[id='bg_b_model']")

    for e in template_model_a:
        template_model_a.remove(e)

    for e in template_model_b:
        template_model_b.remove(e)

    template_model_a.extend(model_a)
    template_model_b.extend(model_b)

    template_root.write("/tmp/test" + str(current_arg) + ".xml")
