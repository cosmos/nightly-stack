#!/usr/bin/env python3
import importlib.util
import sys
import os

import json
import yaml

from subprocess import check_output

from os.path import isfile

repo_owner = os.environ.get('REPO_OWNER', os.environ.get('GITHUB_REPOSITORY_OWNER'))

TESTABLE_PLATFORMS = ["linux/amd64"]

def load_metadata_file_yaml(file_path):
    with open(file_path, "r") as f:
        return yaml.safe_load(f)

def load_metadata_file_json(file_path):
    with open(file_path, "r") as f:
        return json.load(f)

def get_app_metadata(subdir, meta, forRelease=False, channels=None):
    appsToBuild = {
        "apps": [],
        "appsPlatforms": []
    }

    if channels is None:
        channels = meta["channels"]
    else:
        channels = [channel for channel in meta["channels"] if channel["name"] in channels]


    for channel in channels:

        # App Name
        toBuild = {}
        toBuild["name"] = meta["app"]
        toBuild["channel"] = channel["name"]
        toBuild["update_modules_enabled"] = channel["update_modules"]["enabled"]
        toBuild["container_tag_name"] = channel["container_tag_name"]

        toBuild["repository"] = meta["repository"]
        toBuild["path"] = meta["path"]
        toBuild["branch"] = channel["branch"]
        toBuild["update_modules"] = channel["update_modules"]
        toBuild["publish_artifacts"] = meta["publish_artifacts"]

        # Container Tags
        toBuild["tags"] = [channel]

        # Platform Metadata
        for platform in channel["platforms"]:

            toBuild.setdefault("platforms", []).append(platform)

            target_os = platform.split("/")[0]
            target_arch = platform.split("/")[1]

            platformToBuild = {}
            platformToBuild["name"] = toBuild["name"]
            platformToBuild["repository"] = toBuild["repository"]
            platformToBuild["path"] = toBuild["path"]
            platformToBuild["branch"] = toBuild["branch"]
            if meta.get("fetch_full_history"):
                platformToBuild["fetch_full_history"] = meta["fetch_full_history"]
            platformToBuild["platform"] = platform
            platformToBuild["target_os"] = target_os
            platformToBuild["target_arch"] = target_arch
            platformToBuild["channel"] = channel["name"]
            platformToBuild["label_type"]="org.opencontainers.image"

            if isfile(os.path.join(subdir, channel["name"], "Dockerfile")):
                platformToBuild["dockerfile"] = os.path.join(subdir, channel["name"], "Dockerfile")
                platformToBuild["context"] = os.path.join(subdir, channel["name"])
                platformToBuild["goss_config"] = os.path.join(subdir, channel["name"], "goss.yaml")
            else:
                platformToBuild["dockerfile"] = os.path.join(subdir, "Dockerfile")
                platformToBuild["context"] = subdir
                platformToBuild["goss_config"] = os.path.join(subdir, "ci", "goss.yaml")

            platformToBuild["goss_args"] = ""

            platformToBuild["tests_enabled"] = channel["tests_enabled"] and platform in TESTABLE_PLATFORMS

            platformToBuild["publish_artifacts"] = meta["publish_artifacts"]
            if meta.get("binary_name"):
                platformToBuild["binary_name"] = meta["binary_name"]

            platformToBuild["update_modules_enabled"] = channel["update_modules"]["enabled"]
            if channel["update_modules"]["enabled"]:
                platformToBuild["update_modules_branch"] = channel["update_modules"]["cosmossdk_branch"]

            appsToBuild["appsPlatforms"].append(platformToBuild)
        appsToBuild["apps"].append(toBuild)
    return appsToBuild

if __name__ == "__main__":
    apps = sys.argv[1]
    forRelease = sys.argv[2] == "true"
    appsToBuild = {
        "apps": [],
        "appsPlatforms": []
    }

    if apps != "all":
        channels=None
        apps = apps.split(",")
        if len(sys.argv) == 4:
            channels = sys.argv[3].split(",")

        for app in apps:
            if not os.path.exists(os.path.join("./apps", app)):
                print(f"App \"{app}\" not found")
                exit(1)

            meta = None
            if os.path.isfile(os.path.join("./apps", app, "metadata.yaml")):
                meta = load_metadata_file_yaml(os.path.join("./apps", app, "metadata.yaml"))
            elif os.path.isfile(os.path.join("./apps", app, "metadata.json")):
                meta = load_metadata_file_json(os.path.join("./apps", app, "metadata.json"))

            appToBuild = get_app_metadata(os.path.join("./apps", app), meta, forRelease, channels=channels)
            if appToBuild is not None:
                appsToBuild["apps"].extend(appToBuild["apps"])
                appsToBuild["appsPlatforms"].extend(appToBuild["appsPlatforms"])
    else:
        for subdir, dirs, files in os.walk("./apps"):
            for file in files:
                meta = None
                if file == "metadata.yaml":
                    meta = load_metadata_file_yaml(os.path.join(subdir, file))
                elif file == "metadata.json":
                    meta = load_metadata_file_json(os.path.join(subdir, file))
                else:
                    continue
                if meta is not None:
                    appToBuild = get_app_metadata(subdir, meta, forRelease)
                    if appToBuild is not None:
                        appsToBuild["apps"].extend(appToBuild["apps"])
                        appsToBuild["appsPlatforms"].extend(appToBuild["appsPlatforms"])
    print(json.dumps(appsToBuild))