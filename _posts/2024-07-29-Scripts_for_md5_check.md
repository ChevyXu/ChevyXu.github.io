---
layout: post
title: Scripts for MD5 check
subtitle: 笑抚江南竹根枕，一樽呼起鼻中雷。[对酒 宋 陈与义]
date: "2024-07-29"
author: Chevy
header-img: img/055.png
catalog: true
tags:
  - 技术学习笔记
  - Shell
  - Python
style: plain 
knit: (function(input, encoding) {
  rmarkdown::render(input, output_dir = "../_posts/")})
output: 
  md_document:
    variant: markdown_github
    preserve_yaml: true
  # prettydoc::html_pretty:
  # theme: cayman
  # toc: yes
---

# 本次想要记录使用shell或者python对指定目录下的文件进行md5完整性检验

md5文件一般都会保存在对应文件的相同目录下，需要针对多个子目录挨个进行`md5sum -c`的话未免有点麻烦。

> 需要cd到子文件夹下进行`md5sum -c`

所以函数式样的编程就很方便。

## 主体思考

对每个文件生成md5，并和已经存在的md5进行比较，如果相同就可以`print` Pass

## shell工作记录

``` bash
#!/bin/bash

# Main folder containing subfolders
base_folder="Dunwill_PDX_RNA-seq"

# Output file for results
output_file="file_integrity_check_results.csv"

# Initialize the output file with headers
echo "File,Status" > "$output_file"

# Function to calculate and verify MD5 checksum
verify_md5() {
  local file_path=$1
  local md5_file_path="${file_path}.md5"

  if [ -f "$md5_file_path" ]; then
    # Calculate the MD5 checksum of the file
    calculated_md5=$(md5sum "$file_path" | awk '{ print $1 }')

    # Read the stored MD5 checksum from the .md5 file
    stored_md5=$(awk '{ print $1 }' "$md5_file_path")

    # Compare the calculated MD5 with the stored MD5
    if [ "$calculated_md5" == "$stored_md5" ]; then
      echo "$file_path,Pass" >> "$output_file"
    else
      echo "$file_path,Fail" >> "$output_file"
    fi
  else
    echo "$file_path,MD5 file missing" >> "$output_file"
  fi
}

# Export the function to be used by find command
export -f verify_md5
export output_file

# Find all files (excluding .md5 files) and verify their checksums
find "$base_folder" -type f ! -name "*.md5" -exec bash -c 'verify_md5 "$0"' {} \;

# Find all files (excluding .md5 files) and verify their checksums in parallel
# find "$base_folder" -type f ! -name "*.md5" | parallel -j 14 verify_md5 {} >> "$output_file"

echo "File integrity check completed. Results saved to $output_file."
```

随后保存成sh文件转化为可执行文件跑一下就行了。`chmod +x check_md5_integrity_parallel.sh`
或者直接`bash check_md5_integrity_parallel.sh`

## python 工作记录

``` python
import os
import hashlib
import pandas as pd

def calculate_md5(file_path):
    """Calculate MD5 checksum of the given file."""
    hash_md5 = hashlib.md5()
    with open(file_path, "rb") as f:
        for chunk in iter(lambda: f.read(4096), b""):
            hash_md5.update(chunk)
    return hash_md5.hexdigest()

def verify_md5(file_path, md5_file_path):
    """Verify the MD5 checksum of the given file against the value in the md5 file."""
    calculated_md5 = calculate_md5(file_path)
    with open(md5_file_path, 'r') as f:
        stored_md5 = f.read().strip().split()[0]
    return calculated_md5 == stored_md5

def check_integrity(base_folder):
    results = []
    for subdir, _, files in os.walk(base_folder):
        for file in files:
            if file.endswith(".md5"):
                continue
            file_path = os.path.join(subdir, file)
            md5_file_path = file_path + ".md5"
            if os.path.exists(md5_file_path):
                status = verify_md5(file_path, md5_file_path)
                results.append({
                    "File": file_path,
                    "Status": "Pass" if status else "Fail"
                })
            else:
                results.append({
                    "File": file_path,
                    "Status": "MD5 file missing"
                })
    return results

# Main folder containing subfolders
base_folder = "Dunwill_PDX_RNA-seq"

# Run the integrity check
results = check_integrity(base_folder)

# Convert results to a DataFrame for better readability
df_results = pd.DataFrame(results)
print(df_results)

# Optionally, save the results to a CSV file
df_results.to_csv("file_integrity_check_results.csv", index=False)
```

也是使用命令行运行`python check_md5_integrity.py`
