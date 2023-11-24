#!/usr/bin/bash



# 读取文件中的每一行
while IFS= read -r line; do
    # 切割字符串
    first_part="${line:0:18}"
    second_part="${line:18}"

    # 输出结果，将分割后的文本放在两行
    echo "$first_part"
    echo "$second_part"
done < ../20041.txt > split_data.txt














