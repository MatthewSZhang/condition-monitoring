%% Sample MATLAB code editing
% Testing, testing, 1, 2, 3 -CMD

%% Pulling the code from Github
% I want to pull the code into my working directory

%{
1. In a new working directory I've just created, I have nothing there
(mine is C:\Users\Simon\Github-machinelearning)

2. Open the Git command line, and change directory to your working folder:
cd C:\Users\Simon\Github-machinelearning
(press enter)

3. Initialize your working folder as a git folder:
git init
(this creates a hidden folder called ".git" in your working folder)

4. Direct the connection of Git to our github repository:
git remote add origin https://github.com/cs229-ML/condition-monitoring.git

5. Pull all the updated code into your local working directory:
git pull origin master

5a. Now all the files from github are in your working directory, and it is
up to date.

%}

%% Make a first "commit" to a code
% I've just started writing the code, and I am going to save this code onto
% Github.

%{
1. In my working directory, (mine is C:\Users\Simon\Github-machinelearning)
I have this file, named "Github_stuff.m"

2. I open the Git command line, and navigate to my directory by typing:
cd C:\Users\Simon\Github-machinelearning

3. Add the file onto Git locally:
git add Github_stuff.m

4. Commit the file, with a note in quotes indicating what you've changed:
git commit -m "Initial commit of a MATLAB file"

(everytime you commit, a history line is stored)

5. Indicate the destination of the file:
git remote add origin https://github.com/cs229-ML/condition-monitoring.git
(you only need to do this once, afterward, the "origin already exists"

6. Push (send) the file over to the "origin", which is our github
repository:
git push -u origin master

7. You are prompted for your github username and password. Since you guys
are admins on this project, your username and password will allow the push.

%}
