#!/usr/bin/env python3
import sys

if (len(sys.argv) != 3):
    print("Usage: " + sys.argv[0] + " <ENTITY_COUNT> <ENTITY_CSS_TEMPLATE>")
    print("Params:")
    print("- ENTITY_COUNT: number of classes to produce.")
    print("- ENTITY_CSS_TEMPLATE: template filename.")
    exit(-1)

N = int(sys.argv[1])
CSS_TEMPLATE = sys.argv[2]

with open(CSS_TEMPLATE, 'r') as template_file:
    template=template_file.read()

for i in range(N):
    colors = sys.stdin.readline().strip()
    print(
        template.replace(
            '$ID$',
            str(i)
        ).replace(
            '$COLOR$',
            colors
        )
    )

