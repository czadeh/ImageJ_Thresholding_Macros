import os
import pandas as pd
import tkinter as tk
from tkinter import filedialog

def csv_to_excel_sheet(main_directory):
    dirs = ["cor", "sag", "tra"]
    types = ["local", "global"]
    sheets_written = 0  # Track if we've written any sheets

    # Create a new Excel writer object outside the loop
    excel_path = os.path.join(main_directory, 'combined_results.xlsx')
    writer = pd.ExcelWriter(excel_path, engine='openpyxl')

    for dir_name in dirs:
        for type_name in types:
            csv_path = f"{main_directory}/{dir_name}/{type_name}/{type_name.capitalize()}_Results.csv"
            try:
                df = pd.read_csv(csv_path)
                df.to_excel(writer, sheet_name=f"{dir_name} {type_name}", index=False)

                # Get the current sheet and modify cell A1
                ws = writer.sheets[f"{dir_name} {type_name}"]
                ws["A1"] = "Image Number"

                sheets_written += 1
            except FileNotFoundError:
                print(f"Could not find {csv_path}. Skipping...")

    # Save and close the Excel writer if any sheets were written
    if sheets_written > 0:
        writer.close()
    else:
        raise ValueError("No CSV files were found to process.")

def main():
    root = tk.Tk()
    root.withdraw()
    main_directory = filedialog.askdirectory(title="Please select the main directory")
    
    if main_directory:
        try:
            csv_to_excel_sheet(main_directory)
        except ValueError as e:
            print(e)
    else:
        print("No directory selected. Exiting...")

if __name__ == '__main__':
    main()
