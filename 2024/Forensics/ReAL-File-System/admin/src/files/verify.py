import hashlib
from random import randint
from hidden import QuEsTiOn_Pool ,  Answers

MAX_POINTS = 6

def PoW(l=20):
    x = randint(2 ** (l - 1), 2**l)
    g = randint(2**16, 2**20)
    p = 13066599629066242837866432762953247484957727495367990531898423457215621371972536879396943780920715025663601432044420507847680185816504728360166754093930541
    target = pow(g, x, p)
    print(f"{g}^x mod {p} == {target}")
    try:
        solution = int(input("x: "))
        if solution == x:
            return True
        else:
            return False
    except:
        return False

def isAllAnsweredCorrectly(i, score_board):
    if i==MAX_POINTS:
        for _ in score_board:
            if _ == False: return False
        return True 
    else:
        return False

def checkAns(ans, i):
    if Answers[i] == ans:
        return True 
    return False

def getflag():
    flag = open("flag",'r').read()
    return flag

def check_ans(question, i):
    final_hashes = []
    question.sort()
    for sublist in question:
        sublist.sort()
        concatenated_string = ''.join(sublist)
        hashed_result = hashlib.sha256(concatenated_string.encode()).hexdigest()
        final_hashes.append(hashed_result)
    final_hashes.sort()
    concatenated_hashes = ''.join(final_hashes)
    final_hash = hashlib.sha256(concatenated_hashes.encode()).hexdigest()
    status = checkAns(final_hash, i)
    return status

def run():

    pow_flag = PoW()
    if pow_flag == False: exit()
    score_board = [False] * 6 

    count = 0
    # QUESTIONS = [QUESTION_1, QUESTION_2, QUESTION_3, QUESTION_4, QUESTION_5,QUESTION_6]
    while(count<6):

        print(QuEsTiOn_Pool[count])
        inp_ans = input("=> ")
        # shuffle(QUESTIONS[count])
        # inp_ans = str(QUESTIONS[count])
        try:
            ans = eval(inp_ans)
            if (isinstance(ans, list) and (all(isinstance(item, list) for item in ans ))):
                res = check_ans(ans, count)
                if res:
                    print(f"Correct :) \n")
                    score_board[count] = True 
                    count+=1
                    check = isAllAnsweredCorrectly(count, score_board)
                    if check:
                        print("")
                        print(getflag())
                        break
                else:
                    print("Wrong Answer!!\n")
                    break

        except Exception :
            print("Wrong Format!!\n")
            break