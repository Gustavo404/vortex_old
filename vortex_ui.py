import os
import tkinter as tk
from tkinter import filedialog
from PIL import Image, ImageTk
import subprocess

# Create the window
window = tk.Tk()
window.title("Vortex")

# Set the window size and position
window.geometry("780x510+300+100")
window.eval('tk::PlaceWindow . center')

# Load the logo image
logo_path = os.path.join(os.path.dirname(__file__), ".vortex.png")
logo_image = Image.open(logo_path)
logo_photo = ImageTk.PhotoImage(logo_image)

# Resize the logo image to fit the window
window_width, window_height = window.winfo_width(), window.winfo_height()
logo_image.thumbnail((int(window_width * 0.3), int(window_height * 0.3)))

logo_photo = ImageTk.PhotoImage(logo_image)

# Create a label to display the logo image
logo_label = tk.Label(window, image=logo_photo)
logo_label.pack()

# Create a frame to hold the input fields
frame = tk.Frame(window)
frame.pack(fill="both", expand=True)

# Create the input fields
input_label = tk.Label(frame, text="Arquivo de entrada:")
input_label.pack(pady=5)
input_entry = tk.Entry(frame)
input_entry.pack(pady=5)

# Function to browse for the input file
def browse_file():
    file_path = filedialog.askopenfilename()
    input_entry.delete(0, tk.END)
    input_entry.insert(0, file_path)

# Create the browse button
browse_button = tk.Button(frame, text="Procurar", command=browse_file)
browse_button.pack(pady=5)

ip_label = tk.Label(frame, text="Endereço IP:")
ip_label.pack(pady=5)
ip_entry = tk.Entry(frame)
ip_entry.insert(0, "10.10.100.")
ip_entry.pack(pady=5)

user_label = tk.Label(frame, text="Usuário:")
user_label.pack(pady=5)
user_entry = tk.Entry(frame)
user_entry.insert(0, "GEPON")
user_entry.pack(pady=5)

pass_label = tk.Label(frame, text="Senha:")
pass_label.pack(pady=5)
pass_entry = tk.Entry(frame, show="*")
pass_entry.insert(0, "J2g89@@dw*Lv")
pass_entry.pack(pady=5)

# Function to execute the script
def execute_script():
    input_file = input_entry.get()
    telnet_ip = ip_entry.get()
    telnet_user = user_entry.get()
    telnet_pass = pass_entry.get()

    # Convert the file path to a Unix-style path
    unix_path = "/mnt/" + input_file[0].lower() + input_file[2:].replace("\\", "/")

    print(unix_path)  # Output: /mnt/c/Users/Direct/Documents/vortex/

    # Define the command string to execute
    command_string = f"bash vortex.sh -i '{unix_path}' -s '{telnet_ip}' -u '{telnet_user}' -p '{telnet_pass}'"

    # Execute the command string
    subprocess.call(command_string, shell=True)

# Create the execute button
execute_button = tk.Button(frame, text="Executar", command=execute_script)
execute_button.pack(pady=5)

# Run the main loop
window.mainloop()