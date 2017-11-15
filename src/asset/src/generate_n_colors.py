#!/usr/bin/env python3
# Color generating script adapted from:
# http://www.8bitrobot.com/media/uploads/2011/09/colorgen.txt
## ORIGINAL NOTICE #############################################################
# colorgen.py
#
# Copyright 2011 West - License: Public domain
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
################################################################################

import sys
import math
import itertools
from decimal import *

if (len(sys.argv) != 3):
    print("Usage: " + sys.argv[0] + " <COLORS_COUNT> <OFFSET>")
    print("Params:")
    print("- COLORS_COUNT: int. COLORS_COUNT > 1.")
    print("- OFFSET: int. Do not print the OFFSET first colors")
    exit(-1)

N = int(sys.argv[1])
OFFSET = int(sys.argv[2])

def MidSort (lst):
  if len(lst) <= 1:
    return lst
  i = int(len(lst)/2)
  ret = [lst.pop(i)]
  left = MidSort(lst[0:i])
  right = MidSort(lst[i:])
  interleaved = [item for items in itertools.zip_longest(left, right)
    for item in items if item != None]
  ret.extend(interleaved)
  return ret

# Build list of points on a line (0 to 255) to use as color 'ticks'
max = 255
segs = int(N**(Decimal("1.0")/3))
step = int(max/segs)
p = [(i*step) for i in range(1,segs)]
points = [0,max]
points.extend(MidSort(p))

# Not efficient!!! Iterate over higher valued 'ticks' first (the points
#   at the front of the list) to vary all colors and not focus on one channel.
colors = ["%02X%02X%02X" % (points[0], points[0], points[0])]
prange = 0
total = 1
while total < N and prange < len(points):
  prange += 1
  for c0 in range(prange):
    for c1 in range(prange):
      for c2 in range(prange):
        if total >= N:
          break
        c = "%02X%02X%02X" % (points[c0], points[c1], points[c2])
        if c not in colors:
          colors.append(c)
          total += 1

for i in range(OFFSET,N):
    print(colors[i])
