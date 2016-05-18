---
layout: page
title: "Statistics department cluster"
description: ""
group: 
---
{% include JB/setup %}

The statistics department at ISU has a department cluster with 

## Storage

Basically, your "home" folder, e.g. /home/niemi for me, is not backed up but is accessible by the cluster nodes. 
In contrast, your "work" folder, e.g. /home/niemi/work, which is also called "MyFiles" (https://www.it.iastate.edu/services/storage/myfiles) is backed up but is not accessible to the cluster nodes (but it is accessible elsewhere, e.g. windows terminal servers).

My suggestion is to mainly use [git](https://git-scm.com/)/[github](https://github.com/) for backuping up scripts and raw data and ignore your "work" folder.
Git/github should contain all the files necessary to reproduce your work. 
The small amount of data necessary to create figures should be included in the repository, but the big data files, e.g. MCMC output, should not be included. 
Thus these files will only exist in your home folder. 

### Backing up with `rsync`

If you are worried about the home folder disappearing (which certainly has happened in the past), use [rsync](http://linux.die.net/man/1/rsync) ([some examples](http://www.tecmint.com/rsync-local-remote-file-synchronization-commands/)) to back it up, e.g.

    rsync -avz --no-perms --no-owner --no-group --delete /home/niemi/examples /home/niemi/work/backup/

It is probably best to back up a folder, e.g. examples/, rather than your whole home directory (to avoid backing up unnecessary files, e.g. my R/ directory), but you could create one folder in your home directory that contains all your git repos and then backing up this folder will backup all your work.

If you want to automate this process, you could run the script on logout by adding the command to your `~/.bash_logout` file. 

## Resources

- [Harvard SLURM](https://rc.fas.harvard.edu/resources/running-jobs/)
