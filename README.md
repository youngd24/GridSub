# GridSub

At a previous position we used Sun Grid Engine (SGE) for scheduling jobs on our HPC cluster. While submitting jobs wasn't terribly difficult for us for many users it was insanely complex so I developed this simple submission system to do it on their behalf.

Like most other things in my repos here this is here for posterity and to use as part of my "portfolio" of past work.

Nearly all of this is in Perl, my natively spoken language, including the WebService.

## Structure

```
appmaster - The apps users submit.
dispatcher - The part that runs the apps on compute nodes.
webservice - Automation interface (SOAP) for an IAM system to create users on the grid.
```

I'm trying to include README.md's in each directory as time goes on, mainly so I can see what I was doing at the time.

## Authors

* **Darren Young** - youngd24@gmail.com

