from os import getAppDir, setCurrentDir, execShellCmd, moveDir, sleep
from strutils import split, startsWith, join, replace
from "../../utils" import info
from strformat import fmt
import cligen
import json

var toolJson = readFile(r"..\..\tools\version.json").parseJson()

proc regolith(action: string)=
    var wd = getAppDir()
    setCurrentDir(wd)
    var regolithVersion = toolJson["tools"]["regolith"]
    let regoPath = fmt"..\..\tools\regolith_{regolithVersion}\regolith.exe"
    case action:
    of "run":
        for p in readFile(fmt".\profiles.txt").split("\n"):
            discard execShellCmd(fmt"{regoPath} run {p}")
    of "unlock":
        discard execShellCmd(fmt"{regoPath} unlock")
    of "all":
        discard execShellCmd(fmt"{regoPath} install-all")
    if action.startsWith("install"):
        discard execShellCmd(fmt"{regoPath} {action}")

proc pulsar(tempName: string, names: seq[string])=
    var wd = getAppDir()
    var pulsarVersion = toolJson["tools"]["pulsar"].to(string).replace("\"", "")
    info "Moving Pack files and templates"
    moveDir("./User_templates", fmt"..\..\tools\pulsar_{pulsarVersion}\User_templates")
    sleep(3 * 1000)
    moveDir("./packs", fmt"..\..\tools\pulsar_{pulsarVersion}\packs")
    setCurrentDir(fmt"..\..\tools\pulsar_{pulsarVersion}")
    var nameStr = names.join(" ")
    discard execShellCmd(fmt"pulsar_cli.exe -t {tempName} -o packs {nameStr}")
    info "Moving Pack files and templates back"
    sleep(3 * 1000)
    moveDir("./packs", fmt"{wd}\packs")
    moveDir("./User_templates", fmt"{wd}\User_templates")
    setCurrentDir(wd)

dispatchMulti([regolith], [pulsar])