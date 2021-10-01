import tkinter as tk
from tkinter import ttk
from tkinter import filedialog
from sqlite_info import SQLiteInfo

class SQLiteGUI(tk.Frame):

    def __init__(self, parent, *args, **kwargs):
        tk.Frame.__init__(self, parent, *args, **kwargs) 
        self.parent = parent
        self.parent.geometry('800x800')
        self.make_gui()

    def make_gui(self):
        """
        """
        frm_db_open = tk.LabelFrame(self, text="Target DB")
        btn_open = tk.Button(frm_db_open, text="Open SQLite DB", command=self.open_sqlite_db)
        frm_db_open.rowconfigure(0, weight=1)
        btn_open.grid(row=0, column=0, sticky='news')
        self.txt_db_path = tk.Entry(frm_db_open)
        self.txt_db_path.grid(row=0, column=1, sticky='news')
        frm_db_open.pack(expand=True, fill='x', side='TOP')

    def open_sqlite_db(self):
        """
        """
        self.sqlite_db_path = filedialog.askopenfilename()
        self.txt_db_path.delete(0, tk.END)
        self.txt_db_path.insert(0, self.sqlite_db_path)

if __name__ == '__main__':
    root = tk.Tk()
    SQLiteGUI(root).pack(side="top", fill="both", expand=True)
    root.mainloop()
