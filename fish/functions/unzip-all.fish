# 批量解压 .zip 包
function unzip-all --description "Batch unzip files"
  set -l target_path "."
  if set -q argv[1]
    if test -n "$argv[1]"
      set target_path $argv[1]
    end
  end

  set target_path (realpath "$target_path")

  if not test -d "$target_path"
    echo "Error: Directory '$target_path' does not exist!" >&2
    return 1
  end

  # 确定解压工具
  set -l use_7z false
  set -l extractor ""
  if command -sq 7z
    set extractor 7z
    set use_7z true
    echo "Using 7z as extractor."
  else if command -sq unzip
    set extractor unzip
    echo "7z unavailable, using unzip instead."
  else
    echo "Error: No extractor (7z or unzip) found!" >&2
    return 1
  end

  # 查找所有 .zip 文件
  set -l zip_files (find "$target_path" -maxdepth 1 -name "*.zip" -type f 2> /dev/null)
  set -l zip_count (count $zip_files)

  if test $zip_count -eq 0
    echo "No zip files found in $target_path"
    return 0
  end

  echo "Found $zip_count zip files."

  set -l success_count 0
  set -l skip_count 0
  set -l error_count 0

  for zip_file in $zip_files
    set -l filename (basename "$zip_file")
    set -l base_name (string replace -r -i '\.zip$' '' "$filename")
    set -l extract_dir "$target_path/$base_name"

    # 检查是否为分卷压缩
    set -l is_split false
    if test -f "$target_path/$base_name.z01"
      set is_split true
    else if string match -q -r '\.zip\.\d+$' "$filename"
      set is_split true
    else if string match -q "*part*" "$base_name"
      set is_split true
    else if string match -q -r '\.v\d+$' "$base_name"
      set is_split true
    end

    if test "$use_7z" = false
      # 使用 unzip 时, 如果检查到分卷则跳过
      if test "$is_split" = true
        echo "Warning: '$filename' looks like a volume file, skipped." >&2
        set skip_count (math $skip_count + 1)
        continue
      end
    end

    echo "[*] Extracting: $filename"

    # 创建目标目录
    if not mkdir -p "$extract_dir"
      echo "Error: failed to create '$extract_dir'" >&2
      set error_count (math $error_count + 1)
      continue
    end

    # 执行解压
    set -l cmd_status 0
    if test "$use_7z" = true
      7z x -o"$extract_dir/" -y "$zip_file" >/dev/null 2>&1
      set cmd_status $status
    else
      unzip -q -d "$extract_dir" "$zip_file" >/dev/null 2>&1
      set cmd_status $status
    end

    if test $cmd_status -eq 0
      # 智能去除双层嵌套 (Flatten directory)
      set -l top_items (find "$extract_dir" -mindepth 1 -maxdepth 1)
      if test (count $top_items) -eq 1; and test -d "$top_items[1]"
        set -l inner_dir $top_items[1]
        
        # 使用随机临时目录名过渡, 防止子文件与外层目录重名导致 mv 命令死锁
        set -l tmp_dir "$extract_dir/.tmp_flatten_"(random)
        mv "$inner_dir" "$tmp_dir"

        set -l inner_items (find "$tmp_dir" -mindepth 1 -maxdepth 1)
        if test (count $inner_items) -gt 0
          mv $inner_items "$extract_dir/"
        end
        rmdir "$tmp_dir"

        echo "✅ Successful: $filename -> $base_name/ (flattened nested dir)"
      else
        echo "✅ Successful: $filename -> $base_name/"
      end
      set success_count (math $success_count + 1)
    else
      echo "❌ Failed: $filename (maybe corrupted or locked by password)" >&2
      set error_count (math $error_count + 1)
    end
  end

  # 输出统计结果
  echo ""
  echo "Finished!"
  echo "✅ Success: $success_count"
  if test $skip_count -gt 0
    echo "⚠️ Skip: $skip_count"
  end
  if test $error_count -gt 0
    echo "❌ Fail: $error_count"
  end
end