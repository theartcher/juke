# spotify-app-remote 0.8.0 references these optional classes in metadata.
# They are not required by Juke's App Remote playback flow.
-dontwarn com.fasterxml.jackson.databind.deser.std.StdDeserializer
-dontwarn com.fasterxml.jackson.databind.ser.std.StdSerializer
-dontwarn com.spotify.base.annotations.NotNull
