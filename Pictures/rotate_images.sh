#!/bin/bash

for img in *.png; do
    [ -f "$img" ] || continue

    magick "$img" -rotate 90 "$img.tmp" && mv "$img.tmp" "$img"
done

echo "Done rotating images."
