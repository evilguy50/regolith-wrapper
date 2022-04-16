import cligen
import os
import json
from strformat import fmt
import strutils

var toolJson = readFile(r"..\..\tools\version.json").parseJson()

proc regolith(action: string)=
    var wd = getAppDir()
    setCurrentDir(wd)
    var regolithVersion = toolJson["tools"]["regolith"]
    let regoPath = fmt"..\..\tools\regolith_{regolithVersion}\regolith.exe"
    case action:
    of "run":
        for p in readFile(fmt".\profiles.txt").split("\n"):
            discard os.execShellCmd(fmt"{regoPath} run {p}")
    of "all":
        discard os.execShellCmd(fmt"{regoPath} install-all")
    if action.startsWith("install"):
        discard os.execShellCmd(fmt"{regoPath} {action}")

proc pulsar(tempName: string, names: seq[string])=
    var wd = getAppDir()
    var pulsarVersion = toolJson["tools"]["pulsar"]
    moveDir("./packs", fmt"..\..\tools\pulsar_{pulsarVersion}\packs")
    setCurrentDir(fmt"..\..\tools\pulsar_{pulsarVersion}")
    var nameStr = names.join(" ")
    discard os.execShellCmd(fmt"pulsar_cli.exe -t {tempName} -o packs {nameStr}")
    moveDir("./packs", fmt"{wd}\packs")
    setCurrentDir(wd)

dispatchMulti([regolith], [pulsar])