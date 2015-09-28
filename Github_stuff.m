%% Sample MATLAB code editing

%% Make a first "commit" to a code
% I've just started writing the code, and I am going to save this code onto
% Github.

%{
1. In my working directory, (mine is C:\Users\Simon\Github-machinelearning)
I have this file, named "Github_stuff.m"

2. I open the Git command line, and navigate to my directory by typing:
cd C:\Users\Simon\Github-machinelearning
(press enter)

3. Add the file onto Git locally:
git add Github_stuff.m

4. Commit the file:
git commit -m "Initial commit of a MATLAB file"

5. Indicate the destination of the file:
git remote add origin https://github.com/cs229-ML/condition-monitoring.git
(you only need to do this once, afterward, the "origin already exists"

6. Push (send) the file over to the "origin", which is our github 
repository:
git push -u origin master

7. You are prompted for your github username and password. Since you guys
are admins on this project, your username and password will allow the push.




%}