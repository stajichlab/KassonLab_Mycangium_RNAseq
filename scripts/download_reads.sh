#!/usr/bin/bash -l
module load rclone

rclone cp -P gdrive_ucr:Transfer/Fusarium\ oligoseptatum\ RNA\ Seq ./reads/
