---
layout: page
title: "Statistics department cluster"
description: ""
group: 
---
{% include JB/setup %}

The statistics department at ISU has a department cluster with 

## Storage

Basically, your "home" folder, e.g. /home/niemi for me, is not backed up but is accessible by the cluster nodes. In contrast, your "work" folder, e.g. /home/niemi/work, which is also called "MyFiles" (https://www.it.iastate.edu/services/storage/myfiles) is backed up but is not accessible by the cluster nodes (but it is accessible elsewhere, e.g. windows terminal servers).

My suggestion is to mainly use git/github for backup and file organization and primarily ignore your "work" folder. Git/github should contain all the files necessary to reproduce your work. The small amount of data necessary to create figures should be included in the repository, but he big data files, e.g. MCMC output, should probably not be included. Thus these files will only exist in your home folder. If you are worried about this folder disappearing (which certainly has happened in the past) you could use rsync to backup, e.g.

    rsync -avzh /home/niemi/examples /home/niemi/work/backup/

(I get some `chgrp` errors when using this, but I think this has to do with Windows(Myfiles)/Linux differences.)

It is probably best to back up a folder, e.g. examples/, rather than the whole home directory, but you could create one folder in your home directory that contains all your git repos. 


## Resources

- [Harvard SLURM](https://rc.fas.harvard.edu/resources/running-jobs/)
