configurations.maybeCreate("default")

artifacts.add("default", file("spotify-app-remote-release-0.8.0.aar"))

configurations.maybeCreate("default")

val aarCandidates =
        file(".")
                .listFiles()
                ?.filter {
                    it.isFile &&
                            it.name.startsWith("spotify-app-remote-release-") &&
                            it.extension == "aar"
                }
                ?.sortedByDescending { it.name }
                ?: emptyList()

val aarFile =
        aarCandidates.firstOrNull()
                ?: throw GradleException(
                        "Could not find a Spotify Android SDK AAR file in ${file(".").absolutePath}. " +
                                "Download the release AAR from Spotify and place it in this folder."
                )

artifacts.add("default", aarFile)
