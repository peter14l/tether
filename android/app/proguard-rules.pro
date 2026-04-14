# Keep Supabase and related serialization classes
-keep class io.supabase.** { *; }
-keep class com.google.gson.** { *; }
-keep class org.gotrue.** { *; }
-keep class com.tether.app.app.features.auth.data.models.** { *; }
-keep class com.tether.app.app.features.circles.data.models.** { *; }
-keep class com.tether.app.app.features.feed.data.models.** { *; }
-keepclassmembers class * {
  @com.google.gson.annotations.SerializedName <fields>;
}

# General Flutter & Android keep rules
-keepattributes Signature, *Annotation*, EnclosingMethod
-dontwarn io.flutter.embedding.**
-dontwarn com.google.firebase.**
