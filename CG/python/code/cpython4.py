
from tkinter import *
from tkcalendar import Calendar
import tkinter as tk


window = tk.Tk()

# Adjust size
window.geometry("600x500")

gameList =["Game List:"]
# Change the label text
def show():
    game = selected1.get() + " vs " + selected2.get()+" on "+cal.get_date()
    gameList.append(game)
    gameListshow = "\n".join(gameList)
    label.config(text=gameListshow)

options = [
    "Team 1",
    "Team 2",
    "Team 3",
    "Team 4",
    "Team 5",
    "Team 6"
]

selected1 = StringVar()
selected2 = StringVar()


selected1.set("Team 1")
selected2.set("Team 2")

L1 = Label(window, text="Visitor")
L1.place(x=40, y=35)
drop1 = OptionMenu(window, selected1, *options)
drop1.place(x=100, y=30)

L2 = Label(window, text="VS")
L2.place(x=100, y=80)

L3 = Label(window, text="Home")
L3.place(x=40, y=115)
drop2 = OptionMenu(window, selected2, *options)
drop2.place(x=100, y=110)

cal = Calendar(window, selectmode='day',
               year=2022, month=12,
               day=1)

cal.place(x=300, y=20)

button = Button( window, text="Add to calender", command=show).place(x=100,y=200)

label = Label(window, text=" ")
label.place(x=150, y=250)

window.mainloop()
    