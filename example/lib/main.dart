import 'package:flutter/material.dart';
import 'package:zendesk_helper/zendesk_helper.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: MyPage());
  }
}

class MyPage extends StatefulWidget {
  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  final _zendesk = Zendesk();
  @override
  void initState() {
    super.initState();
    initZendesk();
  }

  Future<String> getJwtToken() async {
    return 'JWT_TOKEN';
  }
  
  Future<void> initZendesk() async {
    if (!mounted) {
      return;
    }
    const _accountKey = 'ACCOUNT_KEY';
    const _appId = 'APP_ID';
    await _zendesk.initialize(
      accountKey: _accountKey,
      appId: _appId,
      getJwtToken: getJwtToken,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Zendesk Chat Plugin'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Initialize  example with proper\nkeys in main.dart',
                textAlign: TextAlign.center,
              ),
            ),
            ElevatedButton(
              onPressed: openChat,
              child: const Text('Open Chat'),
            ),
            ElevatedButton(
              onPressed: clear,
              child: const Text('Clear Chat'),
            )
          ],
        ),
      ),
    );
  }

  Future<void> clear() async {
    await _zendesk.resetIdentity();
  }

  Future<void> openChat() async {
    await _zendesk.setVisitorInfo(
      name: 'NAME',
      email: 'email@email.com',
      phoneNumber: 'phone',
      department: 'DEPARTMENT',
    );
    await _zendesk.addTags(tags: ['tag1', 'tag2']);
    await _zendesk.sendMessage('[Test] auto msg');
    await _zendesk.startChat(
      primaryColor: Colors.red,
      isPreChatFormEnabled: false,
      isAgentAvailabilityEnabled: false,
      isChatTranscriptPromptEnabled: false,
      isOfflineFormEnabled: false,
      toolbarTitle: 'TITLE',
    );
  }
}
