---
layout: page
title: "Set up Git"
description: ""
group: 
---
{% include JB/setup %}

## Version control

I highly recommend [version control](https://en.wikipedia.org/wiki/Version_control) to improve your workflow when writing code, papers, lectures, seminars, etc. I use [Git](https://git-scm.com/) which I recommend to my graduate students so that we are all on the same page, but there are [other options](https://en.wikipedia.org/wiki/List_of_version_control_software). 


## Remote repository

I also highly recommend backing up your work. This can be combined with a version control system by utilizing a remote repository. I use [GitHub](https://github.com/) to host my repository since GitHub provides unlimited open source repositories, unlimited private repositories with the personal plan ($7/month) or an [academic discount](https://education.github.com/). 
To make a private repository public, you just have to hit a button which makes GitHub ideal for reproducible code, manuscripts, etc. 
An alternative is [Bitbucket](https://bitbucket.org/) which provides unlimited private repositories (without a fee or discount), but you must pay for public repositories. 
In the event you wanted to make a repository public that was housed at Bitbucket, you could export the repository to GitHub.
For those affiliated with Iowa State, there are two GitLab repositories available: [EcE](https://git.ece.iastate.edu/) and [LAS](https://git.linux.iastate.edu/).



## Setting Git up from a new computer. 

To [set up Git](https://help.github.com/articles/set-up-git/) you need to 1) [install Git](https://git-scm.com/downloads) and 2) configure Git.
Configuring Git involves these two steps

    git config --global user.name "YOUR NAME"
    git config --global user.email "YOUR EMAIL ADDRESS"
    git config --global push.default simple

as well as setting up your authentication. 
For authentication, I use SSH and thus I [generate an SSH key](https://help.github.com/articles/generating-an-ssh-key/)  on each computer I use and for each remote destination I use. 
Make sure to [test the SSH connection](https://help.github.com/articles/testing-your-ssh-connection/). 


## How to write Git commits

I found [this page](http://chris.beams.io/posts/git-commit/) useful in understanding how to write Git commits. 
Basically, the subject should finish the sentence "If this commit is accepted, it will ...".
Then the body of the message tells that what and why (not the how since that is already in the code).



##  Git from the command line

I typically use Git through [RStudio](https://www.rstudio.com/), but on computation clusters you will need to know Git commands. 
This [cheat sheet](https://www.git-tower.com/blog/git-cheat-sheet/) provides perhaps too many commands. 
The things to remember are 

    git clone git@github.com:<username>/<repo>.git
   
to create a local of the desired repository. Always 

    git pull
    
whenever you start working in a repository, 

    git add <filename>
   
to stage changes to <filename> for committing,

    git status
    
to check what files might need to be staged,

    git commit -m "message"
    
to commit the changes, and

    git push
    
to push those changes to the remote repository. 



## How to start an R package in RStudio with a Git repository

The instructions are from [here](http://stackoverflow.com/questions/17521300/start-new-r-package-development-on-github/17526158#17526158):


1. Create empty repository on github (I will use name rpackage in this example)
1. Create package locally using devtools, create("rpackage") (this will create rpackage folder)
1. Create new project in RStudio (Create project from: Existing directory) and choose rpackage directory
1. In RStudio go to Tools/Shell... and type git init
1. Reopen the project (this will refresh the Git tab)
1. Start Git/More/Shell and type

    git add *
    git commit -m "first commit"
    git remote add origin git@github.com:[username]/rpackage.git
    git push -u origin master

