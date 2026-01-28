import tkinter as tk
from tkinter import messagebox, simpledialog

class TicTacToe:
    def __init__(self, root):
        self.root = root
        self.root.title("Tic-Tac-Toe")
        #self.root.configure(bg='black')

        #Ask players to enter their names
        self.firstplayer = simpledialog.askstring("Input", "Enter First Player's Name:") 
        self.secondplayer = simpledialog.askstring("Input", "Enter Second Player's  Name:") 
        try:
            self.firstsymbol = simpledialog.askstring("Input", "First Player, Choose Your Symbol (X or O):").upper()
        
        #Get first player's symbol and ensures it's either X or O
            if self.firstsymbol not in ["X", "O"]:
                raise ValueError("Invalid Symbol....! Please Choose 'X' or 'O'")
        except ValueError as e:
            messagebox.showerror("Invalid Input")    
            self.firstsymbol = "X"
        #assign opposite symbol to second player
        self.secondsymbol = "O" if self.firstsymbol == "X" else "X"                 
        
        self.current_player = self.firstsymbol
        self.player_names = {self.firstsymbol: self.firstplayer, self.secondsymbol: self.secondplayer}
        self.scores = {self.firstsymbol: 0, self.secondsymbol: 0}
        self.grid = [[None for _ in range(3)] for _ in range(3)]
        
        self.colors = {"X": "blue", "O": "red"}
        #call method to create elements
        self.create_widgets()
    
    def create_widgets(self):
        # create and store button references to grid
        self.buttons = []
        for i in range(3):
            row_buttons = []
            for j in range(3):
                btn = tk.Button(self.root, text="", font=("Arial", 30), height=3, width=6,bg="black",
                                command=lambda r=i, c=j: self.on_click(r, c))
                btn.grid(row=i, column=j)
                row_buttons.append(btn)
            self.buttons.append(row_buttons)
        
        #display players' scores
        self.score_display = tk.Label(self.root, text=self.display_score(), font=("Arial", 20,))
        self.score_display.grid(row=3, column=0, columnspan=3)
    
    def display_score(self):
        return f"{self.firstplayer} ({self.firstsymbol}): {self.scores[self.firstsymbol]} | {self.secondplayer} ({self.secondsymbol}): {self.scores[self.secondsymbol]}"
    
    def on_click(self, row, col):
        try:
        #check if the selected cell is empty before moveing
         if self.buttons[row][col]["text"] == "":
            self.buttons[row][col]["text"] = self.current_player
            self.buttons[row][col]["fg"] = self.colors[self.current_player]
            self.grid[row][col] = self.current_player
            
            #check if the current move resulted in a win, update the score, and display a message
            if self.check_winner():
                self.scores[self.current_player] += 10
                messagebox.showinfo("Congratulations.....!!", f"{self.player_names[self.current_player]} Won The Game!")
                self.restart_game()
                return
            elif self.is_draw():
                messagebox.showinfo("....Game Over....", "It's a Draw!")
                self.restart_game()
                return
            
            #switch the crrent player
            self.current_player = self.secondsymbol if self.current_player == self.firstsymbol else self.firstsymbol
            self.score_display.config(text=self.display_score())
         else:
            messagebox.showwarning("Cell is Taken! Choose Another")
        except Exception as e:
         messagebox.showerror("Error", f"An Unexpected Error Occurred: {str(e)}")   
    
    def check_winner(self):
        try:
             #check win row
         for i in range(3):
            if self.grid[i][0] == self.grid[i][1] == self.grid[i][2] and self.grid[i][0] is not None:
                self.highlight_winner([(i, 0), (i, 1), (i, 2)])
                return True
            #check win column
            if self.grid[0][i] == self.grid[1][i] == self.grid[2][i] and self.grid[0][i] is not None:
                self.highlight_winner([(0, i), (1, i), (2, i)])
                return True
        #chaeck winn diagonal
         if self.grid[0][0] == self.grid[1][1] == self.grid[2][2] and self.grid[0][0] is not None:
            self.highlight_winner([(0, 0), (1, 1), (2, 2)])
            return True
         if self.grid[0][2] == self.grid[1][1] == self.grid[2][0] and self.grid[0][2] is not None:
            self.highlight_winner([(0, 2), (1, 1), (2, 0)])
            return True
        
         return False
        except Exception as e:
         messagebox.showerror("Error", f"An error occurred while checking for a winner: {str(e)}")
        return False
        
    def is_draw(self):
        return all(self.grid[i][j] is not None for i in range(3) for j in range(3))
    
    #hightlight winner to identify easily
    def highlight_winner(self, cells):
        for r, c in cells:
            self.buttons[r][c]["bg"] = "aqua"
    
    #reset the game board for a new round
    def restart_game(self):
        self.current_player = self.firstsymbol
        self.grid = [[None for _ in range(3)] for _ in range(3)]
        for i in range(3):
            for j in range(3):
                self.buttons[i][j]["text"] = ""
                self.buttons[i][j]["bg"] = "peachpuff"
        self.score_display.config(text=self.display_score())

if __name__ == "__main__":
    try:
        root = tk.Tk()
        game = TicTacToe(root)
        root.mainloop()
    except Exception as e:
        messagebox.showerror("Critical Error", f"A critical error occurred: {str(e)}")
        # close the application
        root.quit() 
                