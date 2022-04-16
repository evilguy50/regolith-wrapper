from os import getCurrentDir, getAppDir, dirExists, execShellCmd, removeDir, removeFile
from strutils import multiReplace, replace, contains, strip
from zippy/zipArchives import extractAll
from osproc import execCmdEx
from strformat import fmt
from utils import info
import json

proc downloadTool*(t: string)=
    let root = os.getAppDir()
    var url = "https://api.github.com/repos/$owner/$repo/releases"
    var toolDownload: string
    case t:
    of "pulsar":
        url = url.multireplace(("$owner", "evilguy50"), ("$repo", "pulsar"))
    of "regolith":
        url = url.multireplace(("$owner", "Bedrock-OSS"), ("$repo", "regolith"))
    info fmt"Checking Latest version for {t}"
    var latest = execCmdEx(fmt"powershell.exe (Invoke-WebRequest '{url}' | ConvertFrom-Json)[0].tag_name")[0].strip()
    var version = readFile(os.getAppDir() & r"\tools\version.json").parseJson()["tools"][t].to(string).replace("\"", "").strip()
    case t:
    of "pulsar":
        toolDownload = fmt"http://github.com/evilguy50/Pulsar/releases/download/{latest}/pulsar_windows.zip"
    of "regolith":
        toolDownload = fmt"http://github.com/Bedrock-OSS/regolith/releases/download/{latest}/regolith_{latest}_Windows_x86_64.zip"
    if version != latest:
        version = latest
        info fmt"removing old {t} version"
        for d in os.walkDirs(root & r"\tools"):
            if d.contains(t):
                d.removeDir()
        let toolZip = fmt"{root}\tools\{t}_{version}.zip"
        info fmt"Downloading {t} version {version}"
        discard os.execShellCmd(fmt"powershell.exe curl -Uri {toolDownload} -Outfile " & "\"" & toolZip & "\"")
        extractAll(toolZip, fmt"{root}\tools\{t}_{version}")
        var toolStr = fmt"{root}\tools\version.json"
        var toolJson = toolStr.readFile().parseJson()
        toolJson["tools"][t] = newJString(version)
        toolStr.writeFile(toolJson.pretty())
        removeFile(toolZip)
        info fmt"Finished Downloading {t} version {version}"
    else:
        info fmt"{t} is up to date"