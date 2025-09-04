#!/bin/bash
ffmpeg -framerate 5 -i frame%05d.png -vf "scale=trunc(iw/2)*2:trunc(ih/2)*2" -c:v libx264 -r 30 -pix_fmt yuv420p output.mp4
