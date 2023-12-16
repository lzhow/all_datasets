import random

user_guess = 0
user_continue = True


def generate_number():
    mylist = []
    numlist = [1, 2, 3, 4, 5, 6, 7, 8, 9]
    while len(mylist) < 4:
        x = random.choice(numlist)
        if x not in mylist:  # Making sure that the digits don't repeat in the number
            mylist.append(x)
    return mylist


def user_input():
    correct = False
    global numlist
    while (correct == False):
        try:
            user_number = input("Please guess the 4 digit number, separated by spaces :")
            user_lst = user_number.split(" ")
            user_lt = []
            for i in user_lst:
                i = int(i)
                user_lt.append(i)
            user_list = list(user_lt)
            repeat = check_repeat(user_list)
            if repeat == False:
                for x in user_list:
                    if x == 0:
                        print("Invalid input !! Make sure you enter digits between 1 and 9 !!")
                        correct = False
                        break
                    else:
                        correct = True
                if correct == True:
                    if len(user_list) != 4:
                        correct = False
                        break
                    else:
                        correct = True
            else:
                print("Invalid. Repeat")
                correct = False
        except ValueError:  # A fail safe in case the user enters a space or any other character before a number.
            print(
                "Invalid input !! Please try again !! \nMake sure the input is in the format 'x x x x', where x represents "
                "the digits")
    return user_list


'''bulls : Function to determine the number of bulls, if any'''


def bulls(pc_num, user_num):
    bulls = 0
    global bulls_num
    bulls_num = []
    for i in range(0, 4):
        a = pc_num[i]
        b = user_num[i]
        if a == b:
            bulls += 1
            bulls_num.append(b)
    return bulls


'''descard_repitition : Function to make sure that the bulls are not again considered for calculating cows'''


def discard_repetition(bulls_num, user_num):
    for i in bulls_num:
        for j in user_num:
            if i == j:
                user_num.remove(j)
    return user_num


def check_repeat(user_list):
    if len(set(user_list)) == 4:
        repeat = False
    else:
        repeat = True
    return repeat


'''cows : Function to determine the number of cows'''


def cows(pc_num, new_user_num):
    cows = 0
    for num in new_user_num:
        if num in pc_num:
            cows += 1
    return cows


'''player_wins : Function to determine if the player has won or not'''


def player_wins(bulls):
    global game_continue
    global user_guess
    if bulls == 4:
        user_guess += 1
        print("Congratulations !!! You win !!!")
        print("Number of guesses = " + str(user_guess))
        game_continue = False
    else:
        user_guess += 1
        game_continue = True
    return game_continue


'''main_func : Function to run the basic code'''


def main_func():
    global user_continue
    game_continue = True
    pc_num = generate_number()
    print("The Computer has randomly generated a four digit number, where each digit is between 1 and 9 and is unique "
          "in the number.")
    while (game_continue):
        user_num = user_input()
        result_bulls = bulls(pc_num, user_num)
        new_user_num = discard_repetition(bulls_num, user_num)
        result_cows = cows(pc_num, new_user_num)
        print("Cows = " + str(result_cows))
        print("Bulls = " + str(result_bulls))
        game_continue = player_wins(result_bulls)
    invalid = True
    while (invalid):  # Ask the user if they want to play again
        user_cont = input("Do you want to play again? Press 'y' for yes and 'n' for no")
        if user_cont[0].lower() == "n":  # Account for typos (consider Y/Yes/y/yes)
            user_continue = False
            invalid = False
        elif user_cont[0].lower() == "y":  # Consider N/No/n/no
            invalid = False
        else:  # For any other input
            print("I don't understand !!!")


print("Welcome to Cows and Bulls Game !!!")

while (user_continue):
    main_func()
