#!/bin/bash

source_dir=$1
destination_dir=$2
job=$3

mkdir -p "$destination_dir"

# 查找源目录下的所有文件和目录，并使用 parallel 并行执行 rsync
# -j <num_jobs> 控制并发进程数，例如 -j 4 表示同时运行 4 个 rsync 进程
# -0 处理文件名中的特殊字符
# --xargs 表示将 find 的输出作为参数传递给 parallel
find "$source_dir" -depth -print0 | parallel -0 -j "$job" rsync -a --info=progress2 {} "$destination_dir"

echo "复制完成"