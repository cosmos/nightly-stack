---
app: cosmos-sdk
repository: cosmos/cosmos-sdk
path: simapp
publish_artifacts: true
channels:
  - name: v0.50.x
    branch: refs/heads/release/v0.50.x
    # platforms: ["linux/amd64","linux/arm64"]
    platforms: ["linux/amd64"]
    container_tag_name: "0.50"
    update_modules:
      enabled: false
    tests_enabled: true
  # - name: v0.50.x-mods
  #   branch: refs/heads/release/v0.50.x
  #   platforms: ["linux/amd64","linux/arm64"]
  #   container_tag_name: 0.50-mods
  #   update_modules:
  #     enabled: true
  #     cosmossdk_branch: refs/heads/release/v0.50.x
  #   tests_enabled: true
  # - name: v0.52.x
  #   branch: refs/heads/release/v0.52.x
  #   platforms: ["linux/amd64","linux/arm64"]
  #   container_tag_name: "0.52"
  #   update_modules:
  #     enabled: false
  #     cosmossdk_branch: refs/heads/release/v0.52.x
  #   tests_enabled: true