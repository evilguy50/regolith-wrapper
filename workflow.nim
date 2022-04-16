from os import getAppDir, dirExists, createDir, setCurrentDir, execShellCmd, copyDir, copyFile
from utils import setEnv, global
from tools import downloadTool
from strformat import fmt
import cligen

downloadTool("pulsar")
downloadTool("regolith")

proc workflow(base, author, project: string)=
    var root = getAppDir()
    if not dirExists(fmt"{root}/projects"):
        createDir(fmt"{root}/projects")
    if not dirExists(fmt"{root}/templates/{base}"):
        echo fmt"Template {base} not found"
        quit(1)
    copyDir(fmt"{root}/templates/{base}", fmt"{root}/projects/{project}")
    copyFile(fmt"{root}\tools\interface\work.exe", fmt"{root}\projects\{project}\work.exe")
    setEnv(author, project)
    project.global()
    setCurrentDir(fmt"{root}/projects/{project}")
    discard execShellCmd("./work.exe regolith -a unlock")
    setCurrentDir(root)

dispatch(workflow)