import random

data = open('instructions.bin', 'rb').read()

split_up_data = [data[i:i+7] for i in range(0, len(data), 7)]
random_list = []

for i in range(len(split_up_data)):
    random_list.append(random.randint(0, 1126))

for index, random_number in enumerate(random_list):
    split_up_data[i], split_up_data[random_number] = split_up_data[random_number], split_up_data[i]

f = open('instructions.bin', 'wb')
f.write(b''.join(split_up_data))
f.close()
