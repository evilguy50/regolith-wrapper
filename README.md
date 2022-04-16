# regolith-wrapper
---
A project bootstrapping tool and regolith wrapper with extra functionality

---
## Usage:
### workflow.exe (tool root folder)
./workflow.exe (-b or --base) template (-a or --author) author_name (-p or --project) project_name
#### Example:
./workflow.exe -b default -a evil -p example
### work.exe (project root folder)
#### Regolith:
./work.exe regolith (-a or --action) (run or all or install)
##### run example
the run action runs all profiles inside of profiles.txt (1 profile per line)
./work.exe regolith -a run
##### all example
the all action installs all filters inside of your projects filter definitions key
./work.exe regolith -a all
##### install example
the install action wraps regolith install to install new remote filters
./work.exe regolith -a install github.com/Nusiq/regolith-filters/subfunctions
#### Pulsar
./work.exe pulsar (-t or --tempName [Template List](https://github.com/evilguy50/Pulsar/blob/main/template_info.txt)) (list of names seperated by a space)
##### Example:
./work.exe pulsar basic_block block_one block_two block_three

---
## features:
---
### Tool wrapping:
This tool wraps 2 tools.
Regolith and Pulsar.
#### [Regolith](https://github.com/Bedrock-OSS/regolith)
A tool for running scripts on packs non destructively. 
These scripts are called filters.
#### [Pulsar](https://github.com/evilguy50/Pulsar)
A tool for bootstrapping addon features. You give Pulsar a list of names and a feature template and it creates all the needed files for you.
### Auto updating tools:
Regolith and Pulsar will update to the latest release when you make a new project.
### Pack initialization:
When you create a new project a blank addon will be created for you.
### Global filter definitions:
Quickly define filters in new projects by defining them inside the global config.
The global config does NOT install the filters for you. so make sure to run ``work.exe regolith -a all` to install the filters locally.
### Auto run multiple profiles:
Profile runtimes are set in your projects profiles.txt file.
each line runs a different profile.
### Project templates:
Easilly create projects using templates.
If you don't want to use the default template you can make your own by putting a regolith project in the template folder and enchancing the files/folders with a few variables:
#### Variable list:
All variables are prefixed with $
uuid1
uuid2
uuid3
uuid4
author
packName