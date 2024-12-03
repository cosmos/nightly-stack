
#Spec: {
    app:        #AppName
    repository: string
    path:       string
    fetch_full_history?: bool
    publish_artifacts: bool
    binary_name?: string
    binary_build_output_path?: string
    channels: [...#Channels]
}

#Channels: {
    name:     #ChannelName
    platforms: [...#Platforms]
    branch:    string
    container_tag_name: string
    update_modules: {
        enabled: bool
        cosmossdk_branch?: string
    }
    tests_enabled: bool
}

#AppName:     string & !="" & =~"^[a-zA-Z0-9_-]+$"
#ChannelName: string & !="" & =~"^[a-zA-Z0-9._-]+$"
#Platforms:   "linux/amd64" | "linux/arm64"
