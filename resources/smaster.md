---
layout: page
title: "Statistics department cluster"
description: ""
group: 
---
{% include JB/setup %}

The statistics department at ISU has a department cluster with a Simple Linux Utility for Resource Management ([SLURM controller](http://it.las.iastate.edu/slurm-simple-linux-utility-resource-management)). 

## Storage

Basically, your "home" folder, e.g. /home/niemi for me, is not backed up but is accessible by the cluster nodes. 
In contrast, your "work" folder, e.g. /home/niemi/work, which is also called "MyFiles" (https://www.it.iastate.edu/services/storage/myfiles) is backed up but is not accessible to the cluster nodes (but it is accessible elsewhere, e.g. windows terminal servers).

My suggestion is to mainly use [git](https://git-scm.com/)/[github](https://github.com/) for backuping up scripts and raw data and ignore your "work" folder.
Git/github should contain all the files necessary to reproduce your work. 
The small amount of data necessary to create figures should be included in the repository, but the big data files, e.g. MCMC output, should not be included. 
Thus these files will only exist in your home folder. 

### Backing up with `rsync`

If you are worried about the home folder disappearing (which certainly has happened in the past), use [rsync](http://linux.die.net/man/1/rsync) ([some examples](http://www.tecmint.com/rsync-local-remote-file-synchronization-commands/)) to back it up, e.g.

    rsync -avz --no-perms --no-owner --no-group --delete /home/niemi/examples /net/my.files.iastate.edu/ifs/isu/las/dept/stat/ds/niemi/backup/

This destination is equivalent to `/home/niemi/work` but that symbolic link sometimes breaks so this version is more stable.
It is probably best to back up a folder, e.g. examples/, rather than your whole home directory (to avoid backing up unnecessary files, e.g. my R/ directory), but you could create one folder in your home directory that contains all your git repos and then backing up this folder will backup all your work.

If you want to automate this process, you could run the script on logout by adding the command to your `~/.bash_logout` file. 

### workflowHelper on smaster

Will Landau, an alumni, created a package to help manage simulation studies and real data analysis that utilize makefiles (specifically the remake R package) called [workflowHelper](https://github.com/wlandau/workflowHelper). 
This package is useful when simulating data, performing an analysis, or calculating summary statistics is time consuming.
It is also useful when you want to easily re-run a simulation study due to bugs in code or add an additional analysis to the study. 


To use this package on smaster, I changed two things

    1. Add `begin = c("SHELL=srun\n.SHELLFLAGS= -N1 -n1 bash -c\n\n")` to `workflow.R`. 
    1. Add `module load R` to your `~/.bash_profile` on smaster. 
    
Basically to get parallelization on the SLURM cluster, we run each job through its own `srun` command. 
This gets accomplished by changing the `SHELL` in the makefile.
But every time we send a job to a node, we need the node to execute `module load R` to make sure we have access to R. 
This gets accomplished by the additional line in the `.bash_profile` that gets executed when logging into the node.

There are probably alternative approaches but this is what I got to work.
Also, you can modify the flags for whatever is appropriate in your application.

To run this, you will use `make` with parallelization `-j`. 
For example, to run 4 parallel jobs use 

    make -j 4 > test.out 2> err.out
    
which will send standard output to `test.out` and standard error to `err.out`. 
For some reason, much more goes to standard error than would be expected on this server. 


## Resources

- [ISU Slurm basics](http://researchit.las.iastate.edu/slurm-basics)
- [ISU Slurm for Statistics](http://it.las.iastate.edu/slurm-simple-linux-utility-resource-management)
- [Harvard SLURM](https://rc.fas.harvard.edu/resources/running-jobs/)
