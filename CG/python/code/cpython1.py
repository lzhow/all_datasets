import random


def print_board(board):
    print(str(board[7]) + ' | ' + str(board[8]) + ' | ' + str(board[9]))
    print('---------')
    print(str(board[4]) + ' | ' + str(board[5]) + ' | ' + str(board[6]))
    print('---------')
    print(str(board[1]) + ' | ' + str(board[2]) + ' | ' + str(board[3]))


def player_input():
    marker = ''
    while marker.upper() != 'X' and marker.upper() != 'O':
        marker = input('Player 1: Choose your marker : ')
    if marker.upper() == 'X':
        return 'X', 'O'
    else:
        if marker.upper() == 'O':
            return 'O', 'X'


def place_marker(board, marker, pos):
    board[pos] = marker


def win_check(board, mark):
    return ((board[1] == mark and board[2] == mark and board[3] == mark) or  # row 1
            (board[4] == mark and board[5] == mark and board[6] == mark) or  # row 2
            (board[7] == mark and board[8] == mark and board[9] == mark) or  # row 3
            (board[1] == mark and board[4] == mark and board[7] == mark) or  # column 1
            (board[2] == mark and board[5] == mark and board[8] == mark) or  # column 2
            (board[3] == mark and board[6] == mark and board[9] == mark) or  # column 3
            (board[3] == mark and board[5] == mark and board[7] == mark) or  # diagonal
            (board[1] == mark and board[5] == mark and board[9] == mark))  # diagonal


def choose_first():
    flip = random.randint(0, 1)
    if flip == 0:
        return 'Player 1'
    else:
        return 'Player 2'


def space_check(board, pos):
    return pos in range(1, 10) and board[pos] == ' '


def full_board_check(board):
    for i in range(1, 10):
        if space_check(board, i):
            return False
    return True


def player_choice(board):
    position = 0
    while not space_check(board, position):
        position = int(input('Choose a position (1-9)'))
    return position


def replay():
    choice = input('Do you want to play again? Enter y/n')
    return choice.lower() == 'y'


print('Welcome to Tic Tac Toe')

while True:
    the_board = [' '] * 10
    player1_marker, player2_marker = player_input()
    turn = choose_first()
    print(turn + ' will go first')
    play_game = input('Ready to play ? y/n')
    if play_game.lower() == 'y':
        game_on = True
    else:
        game_on = False

    while game_on:
        if turn == 'Player 1':
            print_board(the_board)
            position = player_choice(the_board)
            place_marker(the_board, player1_marker, position)

            if win_check(the_board, player1_marker):
                print_board(the_board)
                print('PLAYER 1 HAS WON !!!')
                game_on = False
            else:
                if full_board_check(the_board):
                    print_board(the_board)
                    print('ITS A TIE !!!')
                    game_on = False
                else:
                    turn = 'Player 2'

        else:
            print_board(the_board)
            position = player_choice(the_board)
            place_marker(the_board, player2_marker, position)
            if win_check(the_board, player2_marker):
                print_board(the_board)
                print('PLAYER 2 HAS WON !!!')
                game_on = False
            else:
                if full_board_check(the_board):
                    print_board(the_board)
                    print('ITS A TIE !!!')
                    game_on = False
                else:
                    turn = 'Player 1'

    if not replay():
        break
