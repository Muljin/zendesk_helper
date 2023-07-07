# zendesk plugin

A Flutter plugin for the Zendesk Chat SDK v2

## Getting Started

### Android Setup

You must set a compatible theme theme in the AndroidManifest.xml file's <application> tag. The details are outlined on the [zendesk forums](https://develop.zendesk.com/hc/en-us/community/posts/360043932734/comments/360011819933).

The example Android setup follows the pattern described in the post.

### iOS Setup

Create a new "Run Scripts Phase" in your target's "Build Phases".

This script should be the last step in your project's "Build Phases". Paste the following snippet into the script text field:

```bash
"${BUILT_PRODUCTS_DIR}/${FRAMEWORKS_FOLDER_PATH}/ChatSDK.framework/strip-frameworks.sh"
```

Deployment Target >= `10.0`

## Usage

Initializing the plugin
Authenticating users with JWT
To identify users with an email and name, it is necessary to generate a jwt token, instructions to obtain the JWT secret can be found [here](https://developer.zendesk.com/documentation/classic-web-widget-sdks/chat-sdk-v2/working-with-the-chat-sdk/enabling-authenticated-users-with-the-chat-sdk-/#generating-a-chat-shared-secret).

```dart
Future<String> getJwtToken(){
    // your implementation
}
final zendesk = Zendesk()
await zendesk.initialize(
    accountKey: <account key>,
    appId: <application id>),
    getJwtToken: getJwtToken,
)
```

Setting visitor information (optional)

```dart
await zendesk.setVisitorInfo(
    name: 'Text Client',
    email: 'test+client@example.com',
    phoneNumber: '0000000000',
    department: 'Support',
);
```

Adding and removing tags

```dart
await zendesk.addTags(['tag1', 'tag2', 'tag3']);
await zendesk.removetags(['tag1', 'tag3'])

// Result is only tag2 will be present on the chat
```

Open chat client

```dart
zendesk.startChat(primaryColor: Colors.red,isDarkTheme:true);

// Note: primaryColor and isDarkTheme will only configure iOS. Android AppBar color
// is controlled by the app's theme
```

Resetting Visitor Identity

```dart
await zendesk.resetIdentity();
// Note: Resets the visitor details and end any ongoing chat including chat log history
```

Sending a Chat Message

```dart
await zendesk.sendMessage('hello world');
```
