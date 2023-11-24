#!/d/Study_2/Python/python


input_file_path = "C:\\Users\\Xupujun\\Desktop\\cordic\\data.txt"  # 文件路径

with open(input_file_path, "r") as file:
    content = file.read()


with open(input_file_path, "r") as file:
    line_count = sum(1 for _ in file)


lines = content.splitlines()
line_to_process1 = lines[line_count-2]
line_to_process2 = lines[line_count-1]

# 打印输出每行的内容
print(line_to_process1)
print(line_to_process2)


hex_value1 = line_to_process1
hex_value2 = line_to_process2

binary_value1 = bin(int(hex_value1, 16))[2:].zfill(48)
binary_value2 = bin(int(hex_value2, 16))[2:].zfill(48)

print(binary_value1)
print(binary_value2)

result_value1 = 0
result_value2 = 0
for i in range(13, 48):
    if(int(binary_value1[i])):
        result_value1 = result_value1 + (0.5)**(i-13)
    if(int(binary_value2[i])):
        result_value2 = result_value2 + (0.5)**(i-13)


if (binary_value1[0] == '1'):
    result_value1 = - result_value1
if (binary_value2[0] == '1'):
    result_value2 = - result_value2

print(result_value1)
print(result_value2)



output_file_path = "output.txt"

with open(output_file_path, "w") as file:
    file.write(str(result_value1) + '\n')
    file.write(str(result_value2) + '\n')
