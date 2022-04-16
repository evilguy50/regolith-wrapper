from os import getAppDir, dirExists, createDir, setCurrentDir, execShellCmd, copyDir, copyFile
from utils import setEnv, global, info, error
from tools import downloadTool
from strformat import fmt
import colorize
import cligen

downloadTool("pulsar")
downloadTool("regolith")

proc workflow(base, author, project: string)=
    var root = getAppDir()
    if not dirExists(fmt"{root}/projects"):
        createDir(fmt"{root}/projects")
        info "Creating Projects directory"
    if not dirExists(fmt"{root}/templates/{base}"):
        error fmt"Template {base} not found"
        quit(1)
    info fmt"Creating project {project}"
    copyDir(fmt"{root}/templates/{base}", fmt"{root}/projects/{project}")
    copyFile(fmt"{root}\tools\interface\work.exe", fmt"{root}\projects\{project}\work.exe")
    setEnv(author, project)
    project.global()
    setCurrentDir(fmt"{root}/projects/{project}")
    info fmt"Unlocking project {project}"
    discard execShellCmd(fmt"{root}/projects/{project}/work.exe regolith -a unlock")
    info fmt"Project {project} Created"
    setCurrentDir(root)

dispatch(workflow)