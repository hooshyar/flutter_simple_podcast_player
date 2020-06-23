# Simple_Podcast_Player

I created the project for myself to figure out how audio players work in flutter, without any kind of state management
 solutions
 or fancy widgets and everything that make me not understand a project in one day.
## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.



##Prerequisites
Clone repository
<code>git clone https://github.com/hooshyar/ </code>

and open <code>pubspec.yaml</code>

run 
<code>flutter packages get</code>

open lib/config.dart and change <code>"podcastList"</code> to your list of favorite podcasts

```dart
final List<String> podcastList = [
  'joerogan',
  'the daily',
  'chawg',
  '1619',
  'Ted Radio Hour'
];
```

run app on a simulator
<code>flutter run</code>
on error do the following setup for each platform

###Platform specific configuration


### Android
add these for playing audio in the background
```xml
<manifest ...>
  <uses-permission android:name="android.permission.WAKE_LOCK"/>
  <uses-permission android:name="android.permission.FOREGROUND_SERVICE"/>
  
  <application ...>
    
    ...
    
    <service android:name="com.ryanheise.audioservice.AudioService">
      <intent-filter>
        <action android:name="android.media.browse.MediaBrowserService" />
      </intent-filter>
    </service>

    <receiver android:name="com.ryanheise.audioservice.MediaButtonReceiver" >
      <intent-filter>
        <action android:name="android.intent.action.MEDIA_BUTTON" />
      </intent-filter>
    </receiver> 
  </application>
</manifest>
```

### iOS

If you wish to connect to non-HTTPS URLS, add the following to your `Info.plist` file:

```xml
<key>NSAppTransportSecurity</key>
<dict>
    <key>NSAllowsArbitraryLoads</key>
    <true/>
    <key>NSAllowsArbitraryLoadsForMedia</key>
    <true/>
</dict>
```

Insert this in your `Info.plist` file for Audio service:

```
	<key>UIBackgroundModes</key>
	<array>
		<string>audio</string>
	</array>
```

