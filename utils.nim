from os import walkDirRec, moveDir, copyFile, copyDir, createDir, pcDir, setCurrentDir, getAppDir, execShellCmd
from strutils import multiReplace, replace, contains
from uuids import genUUID, `$`
from strformat import fmt
import json

var root = os.getAppDir()

proc setEnv*(author, project: string)=
    var
        pulsarVersion = readFile(root & r"\tools\version.json").parseJson()["tools"]["pulsar"].to(string)
        regolithVersion = readFile(root & r"\tools\version.json").parseJson()["tools"]["regolith"].to(string)
        uuid1 = genUUID()
        uuid2 = genUUID()
        uuid3 = genUUID()
        uuid4 = genUUID()
    for f in os.walkDirRec(fmt"{root}/projects/{project}"):
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
        if d.contains("$packName"):
            d.moveDir(d.replace("$packName", project))
    copyDir(fmt"{root}/tools/pulsar_{pulsarVersion}/User_templates", fmt"{root}/global_pulsar")
    copyDir(fmt"{root}/tools/pulsar_{pulsarVersion}/User_templates", fmt"{root}/projects/{project}/User_templates")

proc global*(project: string)=
    let config = readFile(fmt"{root}\global_config.json").parseJson()
    var local = fmt"{root}\projects\{project}\config.json"
    var localJson = local.readFile().parseJson()
    localJson["regolith"]["filterDefinitions"] = config["filterDefinitions"]
    local.writeFile(localJson.pretty())
    for f in os.walkDirRec(fmt"{root}\global_pulsar"):
        f.copyFile(f.replace(fmt"{root}\global_pulsar\", fmt"{root}\projects\{project}\User_templates\"))
