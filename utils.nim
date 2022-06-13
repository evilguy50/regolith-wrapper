from os import walkDirRec, moveDir, copyFile, copyDir, createDir, pcDir, setCurrentDir, getAppDir, execShellCmd
from strutils import multiReplace, replace, contains
from uuids import genUUID, `$`
from strformat import fmt
import json
import colorize

var root = os.getAppDir()

proc info*(msg: string)=
    echo "[" & fgCyan("Info") & "]: " & fgLightBlue(msg)

proc error*(msg: string)=
    echo "[" & fgRed("Error") & "]: " & fgLightRed(msg)

proc setEnv*(author, project: string)=
    var
        pulsarVersion = readFile(root & r"\tools\version.json").parseJson()["tools"]["pulsar"].to(string)
        regolithVersion = readFile(root & r"\tools\version.json").parseJson()["tools"]["regolith"].to(string)
        uuid1 = genUUID()
        uuid2 = genUUID()
        uuid3 = genUUID()
        uuid4 = genUUID()
    info "Changing template variables"
    for f in os.walkDirRec(fmt"{root}/projects/{project}"):
        if f.contains(".regolith"): continue
        f.writeFile(f.readFile().multiReplace(
            ("$author", author), 
            ("$packName", project),
            ("$pulsarVersion", pulsarVersion),
            ("$regolithVersion", regolithVersion),
            ("$uuid1", $uuid1),
            ("$uuid2", $uuid2),
            ("$uuid3", $uuid3),
            ("$uuid4", $uuid4)
        ))
    for d in walkDirRec(fmt("{root}/projects/{project}"),yieldFilter = {pcDir}):
        if d.contains(".regolith"): continue
        if d.contains("$packName"):
            d.moveDir(d.replace("$packName", project))
    info "Adding User templates folder structure"
    copyDir(fmt"{root}/tools/pulsar_{pulsarVersion}/User_templates", fmt"{root}/global_pulsar")
    copyDir(fmt"{root}/tools/pulsar_{pulsarVersion}/User_templates", fmt"{root}/projects/{project}/User_templates")

proc global*(project: string)=
    info "Adding global filter definitions to project"
    let config = readFile(fmt"{root}\global_config.json").parseJson()
    var local = fmt"{root}\projects\{project}\config.json"
    var localJson = local.readFile().parseJson()
    localJson["regolith"]["filterDefinitions"] = config["filterDefinitions"]
    local.writeFile(localJson.pretty())
    info "Adding global User templates to project"
    for f in os.walkDirRec(fmt"{root}\global_pulsar"):
        f.copyFile(f.replace(fmt"{root}\global_pulsar\", fmt"{root}\projects\{project}\User_templates\"))
