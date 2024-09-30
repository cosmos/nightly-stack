---
app: ibc-go
repository: cosmos/ibc-go
path: simapp
publish_artifacts: true
channels:
  - name: main
    platforms: ["linux/amd64","linux/arm64"]
    branch: main
    container_tag_name: main
    update_modules:
      enabled: true
      cosmossdk_branch: main
    tests_enabled: true
