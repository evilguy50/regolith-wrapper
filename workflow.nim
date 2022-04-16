import cligen
import os
import strutils
from strformat import fmt
from tools import downloadTool
from utils import setEnv, buildWork, global

downloadTool("pulsar")
downloadTool("regolith")

proc workflow(base, author, project: string)=
    var root = os.getAppDir()
    if not os.dirExists(fmt"{root}/projects"):
        createDir(fmt"{root}/projects")
    if not os.dirExists(fmt"{root}/templates/{base}"):
        echo fmt"Template {base} not found"
        quit(1)
    copyDir(fmt"{root}/templates/{base}", fmt"{root}/projects/{project}")
    copyFile(fmt"{root}\tools\interface\work.exe", fmt"{root}\projects\{project}\work.exe")
    setEnv(author, project)
    project.global()

dispatch(workflow)