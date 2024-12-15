#!/bin/bash

ffmpeg -framerate 10 -pattern_type glob -i 'robot_positions_*.png' -c:v libx264 -pix_fmt yuv420p simulation.mp4
