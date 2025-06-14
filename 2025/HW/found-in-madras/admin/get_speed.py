speeds = []
max_val = 0
with open('canlog6', 'r') as file:
    lines = file.readlines()
    for line in lines:
        if "vcan1" in line and "423" in line:
            parts = line.strip().split()
            low = parts[3]
            high = parts[4]
            speed = high + low 
            if speed not in speeds:
                speeds.append(speed)

for i in speeds:
    if int(i,16) > max_val:
        max_val = int(i,16)
        
max_val = (max_val*0.01)-100
print(max_val)

        