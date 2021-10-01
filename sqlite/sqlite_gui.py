import tkinter as tk
from tkinter import ttk
from tkinter import filedialog
from sqlite_info import SQLiteInfo

class SQLiteGUI(tk.Frame):

    def __init__(self, parent, *args, **kwargs):
        tk.Frame.__init__(self, parent, *args, **kwargs) 
        self.parent.geometry('400X800')
        self.parent = parent
        self.make_gui()

    def make_gui(self):
        """
        """
        btn_open = tk.Button(self, text="Open SQLite DB", command=self.open_sqlite_db)
        btn_open.pack()

    def open_sqlite_db(self):
        """
        """
        self.sqlite_db_path = filedialog.askopenfilename()
        print(self.sqlite_db_path)

if __name__ == '__main__':
    root = tk.Tk()
    SQLiteGUI(root).pack(side="top", fill="both", expand=True)
    root.mainloop()
