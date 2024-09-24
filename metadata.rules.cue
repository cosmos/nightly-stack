
#Spec: {
    app:        #AppName
    repository: string
    path:       string
    build_command: string
    build_artifacts: bool
    channels: [...#Channels]
}

#Channels: {
    name:     #ChannelName
    platforms: [...#Platforms]
    branch:    string
    update_modules?: bool
    tests: {
        enabled: bool
        command: string
    }
}

#AppName:     string & !="" & =~"^[a-zA-Z0-9_-]+$"
#ChannelName: string & !="" & =~"^[a-zA-Z0-9._-]+$"
#Platforms:   "linux/amd64" | "linux/arm64"