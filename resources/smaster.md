---
layout: page
title: "Statistics department cluster"
description: ""
group: 
---
{% include JB/setup %}

The statistics department at ISU has a 
[department cluster](https://stat.iastate.edu/statistics-slurm-cluster) 
with a Simple Linux Utility for Resource Management 
([SLURM](http://it.las.iastate.edu/slurm-simple-linux-utility-resource-management))
controller.
This cluster is accessed by sshing into **smaster.stat.iastate.edu** from 
campus or when connect to the [ISU VPN](https://www.it.iastate.edu/howtos/vpn).

## Storage

Basically, your "home" folder, e.g. /home/niemi for me, is not backed up but is accessible by the cluster nodes. 
In contrast, 
your "work" folder, e.g. /home/niemi/work, which is also called "MyFiles" (https://www.it.iastate.edu/services/storage/myfiles) is backed up but is not accessible to the cluster nodes 
(but it is accessible elsewhere, e.g. windows terminal servers).

My suggestion is to mainly use [git](https://git-scm.com/)/[github](https://github.com/) 
for backuping up scripts and raw data and ignore your "work" folder.
Git/github should contain all the files necessary to reproduce your work. 
The small amount of data necessary to create figures should be included in the repository, but the big data files, e.g. MCMC output, should not be included. 
Thus these files will only exist in your home folder. 

### Backing up with `rsync`

If you are worried about the home folder disappearing 
(which has happened in the past), 
use [rsync](http://linux.die.net/man/1/rsync) 
([some examples](http://www.tecmint.com/rsync-local-remote-file-synchronization-commands/)) to back it up, 
e.g.

    rsync -avz --no-perms --no-owner --no-group --delete /home/niemi/examples /net/my.files.iastate.edu/ifs/isu/las/dept/stat/ds/niemi/backup/

This destination is equivalent to `/home/niemi/work` but that symbolic link sometimes breaks so this version is more stable.
It is probably best to back up a folder, e.g. examples/, rather than your whole home directory (to avoid backing up unnecessary files, e.g. my R/ directory), but you could create one folder in your home directory that contains all your git repos and then backing up this folder will backup all your work.

If you want to automate this process, you could run the script on logout by adding the command to your `~/.bash_logout` file. 




## Running jobs on smaster

Before running jobs on smaster, 
you may want to get a feel for the cluster. 
You can get information about partitions by running 

    sinfo
  
and information about jobs currently being run using 

    squeue
    
or 

    smap
    
    

Most jobs will be run using scripts, 
but before I explain the scripts, I'll mention running jobs interactively as
this is a way to get a feel for the cluster.

### Running jobs interactively

To run a job interactively use

    srun --pty bash
   
If there are a lot of jobs running, 
it may take a while for this job to come up on the queue. 
Thus, you may want to specify the short or medium partition, e.g.

    srun --pty --partition=short bash
    
If you want to specifically get a job on a GPU server use

    srun --pty --partition=short --gres=gpu:1 bash

If you want to use R, you will need to 

    module load R
    
before you can run R.


### Running a batch job

To run a batch job, you will use either `srun` or `sbatch` with an 
[explanation here of the difference](https://stackoverflow.com/questions/43767866/slurm-srun-vs-sbatch-and-their-parameters).

Suppose you have an R script called `test.R` and a SLURM script called `script`
that has the following contents

    #! /bin/bash
    #SBATCH -p short
    #SBATCH -N 1
    #SBTACH -n 2
    module load R
    test.R

Then you can run the job using 

    srun script
    
or 

    sbatch script
    


## Resources

- [ISU Slurm basics](http://researchit.las.iastate.edu/slurm-basics)
- [ISU Slurm for Statistics](http://it.las.iastate.edu/slurm-simple-linux-utility-resource-management)
- [Harvard SLURM](https://rc.fas.harvard.edu/resources/running-jobs/)
