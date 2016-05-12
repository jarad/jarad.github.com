---
layout: page
title: "Resources"
description: ""
group: navigation
---
{% include JB/setup %}

The main purpose of this page is to provide one location for myself and others in the department or university for relevant documents concerning employment at Iowa State University.

# Governance documents

As a faculty member at [Iowa State University](http://www.iastate.edu/) in the [Department of Statistics](http://www.stat.iastate.edu/) which is overseen by both the [College of Liberal Arts and Sciences (LAS)](http://www.las.iastate.edu/) and the [College of Agriculture and Life Sciences (CALS)](https://www.cals.iastate.edu/), the following documents govern my rights at responsibilities at this university:

- [Faculty Handbook](http://www.provost.iastate.edu/faculty-and-staff-resources/faculty-handbook)
- [LAS Faculty Governance](https://www.las.iastate.edu/faculty-staff/faculty-governance/)
- [CALS Governance](https://www.cals.iastate.edu/faculty-staff/governance)
- STAT Governance Document - not available online

# Set up Git

I use [Git](https://git-scm.com/) for version control on all my projects: courses, papers, etc. 
Typically I use [GitHub](https://github.com/) to host my repository since GitHub provides unlimited open source repositories, unlimited private repositories with the personal plan ($7/month) or an academic discount. 
An alternative is [Bitbucket](https://bitbucket.org/) which provides unlimited private repositories, but you must pay for public repositories. 
In the event you wanted to make a repository public that was housed at Bitbucket, you could export the repository to GitHub.
For those affiliated with Iowa State, there are two GitLab repositories available: [EcE](https://git.ece.iastate.edu/) and [LAS](https://git.linux.iastate.edu/).

To [set up Git](https://help.github.com/articles/set-up-git/) you need to 1) [install Git](https://git-scm.com/downloads) and 2) configure Git.
Configuring Git involves these two steps

    git config --global user.name "YOUR NAME"
    git config --global user.email "YOUR EMAIL ADDRESS"
    git config --global push.default simple

as well as setting up your authentication. 
For authentication, I use SSH and thus I [generate an SSH key](https://help.github.com/articles/generating-an-ssh-key/)  on each computer I use and for each remote destination I use. 
Make sure to [test the SSH connection](https://help.github.com/articles/testing-your-ssh-connection/). 

I typically use Git through [RStudio](https://www.rstudio.com/), but on computation clusters you will need to know Git commands. 
This [cheat sheet](https://www.git-tower.com/blog/git-cheat-sheet/) provides perhaps too many commands. 
The things to remember are to 

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



# Amazon shiny server

To setup an Amazon shiny server, I used the following resources:

- <http://www.exegetic.biz/blog/2015/05/hosting-shiny-on-amazon-ec2/>
- <https://www.rstudio.com/products/shiny/download-server/>
- <http://docs.rstudio.com/shiny-server/>
- [Use a more recent version of R](https://www.digitalocean.com/community/tutorials/how-to-set-up-r-on-ubuntu-14-04)
- [Installing necessary R packages globally using staff group](http://stackoverflow.com/questions/3487329/installing-r-packages-available-for-all-users) or [installing using Rstudio server](https://www.rstudio.com/products/rstudio/download-server/)
- [Add swap file since virtual memory was exhausted](http://www.cyberciti.biz/faq/linux-add-a-swap-file-howto/)
