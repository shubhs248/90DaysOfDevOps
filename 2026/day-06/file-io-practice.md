shubhs248@Shubham-Laptop:/mnt/c/Users/shubh/OneDrive/Documents/GitHub/90DaysOfDevOps/2026/day-06$ touch notes.txt
shubhs248@Shubham-Laptop:/mnt/c/Users/shubh/OneDrive/Documents/GitHub/90DaysOfDevOps/2026/day-06$ echo "This is how you push a single string to file" >> notes.txt 
shubhs248@Shubham-Laptop:/mnt/c/Users/shubh/OneDrive/Documents/GitHub/90DaysOfDevOps/2026/day-06$ cat notes.txt 
This is how you push a single string to file
shubhs248@Shubham-Laptop:/mnt/c/Users/shubh/OneDrive/Documents/GitHub/90DaysOfDevOps/2026/day-06$ echo "This should append to the next line" >> notes.txt
shubhs248@Shubham-Laptop:/mnt/c/Users/shubh/OneDrive/Documents/GitHub/90DaysOfDevOps/2026/day-06$ cat notes.txt
This is how you push a single string to file
This should append to the next line
shubhs248@Shubham-Laptop:/mnt/c/Users/shubh/OneDrive/Documents/GitHub/90DaysOfDevOps/2026/day-06$ echo "will later use it to practice display single line through other commands" >> notes.txt
shubhs248@Shubham-Laptop:/mnt/c/Users/shubh/OneDrive/Documents/GitHub/90DaysOfDevOps/2026/day-06$ echo "using tee command to push it altogether" | tee -a notes.txt
using tee command to push it altogether
shubhs248@Shubham-Laptop:/mnt/c/Users/shubh/OneDrive/Documents/GitHub/90DaysOfDevOps/2026/day-06$ cat notes.txt
This is how you push a single string to file
This should append to the next line
will later use it to practice display single line through other commands
using tee command to push it altogether
shubhs248@Shubham-Laptop:/mnt/c/Users/shubh/OneDrive/Documents/GitHub/90DaysOfDevOps/2026/day-06$ #learning to display next
shubhs248@Shubham-Laptop:/mnt/c/Users/shubh/OneDrive/Documents/GitHub/90DaysOfDevOps/2026/day-06$ head -n 3 notes.txt
This is how you push a single string to file
This should append to the next line
will later use it to practice display single line through other commands
shubhs248@Shubham-Laptop:/mnt/c/Users/shubh/OneDrive/Documents/GitHub/90DaysOfDevOps/2026/day-06$ head -n 5 notes.txt
This is how you push a single string to file
This should append to the next line
will later use it to practice display single line through other commands
using tee command to push it altogether
shubhs248@Shubham-Laptop:/mnt/c/Users/shubh/OneDrive/Documents/GitHub/90DaysOfDevOps/2026/day-06$ wc -l notes.txt 
4 notes.txt
shubhs248@Shubham-Laptop:/mnt/c/Users/shubh/OneDrive/Documents/GitHub/90DaysOfDevOps/2026/day-06$ wc -w notes.txt 
36 notes.txt
shubhs248@Shubham-Laptop:/mnt/c/Users/shubh/OneDrive/Documents/GitHub/90DaysOfDevOps/2026/day-06$ ls -lh notes.txt 
-rwxrwxrwx 1 root root 194 Jun  6 16:40 notes.txt
