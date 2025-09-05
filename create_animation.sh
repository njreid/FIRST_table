#!/bin/bash

# This script generates an animation of an OpenSCAD model.
# It first creates a series of PNG images, then combines them into an MP4 video.

# Create a directory for the frames if it doesn't exist
FRAMES_DIR="frames"
if [ ! -d "$FRAMES_DIR" ]; then
  mkdir "$FRAMES_DIR"
fi

# Generate the frames using OpenSCAD
# --animate: specifies the number of frames to generate for the animation
# --viewall: zooms the camera to fit the entire design
# --autocenter: centers the design in the view
openscad-nightly \
  -o "$FRAMES_DIR/frame.png" \
  --animate 20 \
  --imgsize=1200,900 \
  --backend Manifold \
  --colorscheme Nature \
  --viewall \
  --autocenter \
  table.scad

# Combine the frames into a video using ffmpeg
# -framerate: sets the framerate of the input images
# -i: specifies the input files
# -vf: applies a video filter to scale the video dimensions to be even numbers
# -c:v: sets the video codec
# -r: sets the output framerate
# -pix_fmt: sets the pixel format
ffmpeg \
  -framerate 5 \
  -i "$FRAMES_DIR/frame%05d.png" \
  -vf "scale=1200:-1" \
  -c:v libx264 \
  -pix_fmt yuv420p \
  -r 30 \
  -y output.mp4



# Clean up the frames directory
# rm -r "$FRAMES_DIR"

echo "Animation created successfully: output.mp4"
