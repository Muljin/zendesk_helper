import 'dart:async';

import 'package:flutter/services.dart';

/// Provides embed chat functionality
class Zendesk {
  Zendesk() : _channel = const MethodChannel('zendesk');
  final MethodChannel _channel;

  /// Initialize the Zendesk SDK with the provided [accountKey], [appId] and [getjwtToken]
  /// Docs about JWT token authentication: https://developer.zendesk.com/documentation/classic-web-widget-sdks/chat-sdk-v2/working-with-the-chat-sdk/enabling-authenticated-users-with-the-chat-sdk-/#creating-a-jwt-token
  ///
  /// Offical Docs
  /// iOS: https://developer.zendesk.com/embeddables/docs/chat-sdk-v-2-for-ios/getting_started#initializing-the-sdk
  /// Android: https://developer.zendesk.com/embeddables/docs/chat-sdk-v-2-for-android/getting_started#initializing-the-sdk
  Future<void> initialize({
    required String accountKey,
    required String appId,
    required Future<String> Function() getJwtToken,
  }) async {
    _channel.setMethodCallHandler(
      (call) async => call.method == 'getJwt' ? await getJwtToken() : null,
    );
    await _channel.invokeMethod<void>('initialize', {
      'accountKey': accountKey,
      'appId': appId,
    });
  }

  /// Convenience utility to prefill visitor information and optionally set
  /// a support [department]
  Future<void> setVisitorInfo({
    String? name,
    String? email,
    String? phoneNumber,
    String? department,
  }) async {
    await _channel.invokeMethod<void>('setVisitorInfo', {
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'department': department,
    });
  }

  /// Open chat modal.
  ///
  /// Optionally set theme color on iOS using [primaryColor]
  ///
  /// If [isPreChatFormEnabled] is true, the pre-chat form will be shown to the user.
  ///
  /// If [isAgentAvailabilityEnabled] is true, offline message will be shown to the
  /// user in case no agent is available.
  ///
  /// If [isChatTranscriptPromptEnabled] is true, users are asked if they want to request a
  /// chat transcript at the end of the chat.
  ///
  /// If [isOfflineFormEnabled] is true, the offline form will be shown to the user.
  Future<void> startChat({
    bool? isDarkTheme,
    Color? primaryColor,
    bool isPreChatFormEnabled = true,
    bool isAgentAvailabilityEnabled = true,
    bool isChatTranscriptPromptEnabled = true,
    bool isOfflineFormEnabled = true,
    String toolbarTitle = 'Contact Us',
  }) async {
    await _channel.invokeMethod<void>('startChat', {
      'isDarkTheme': isDarkTheme,
      'primaryColor': primaryColor?.value,
      'isPreChatFormEnabled': isPreChatFormEnabled,
      'isAgentAvailabilityEnabled': isAgentAvailabilityEnabled,
      'isChatTranscriptPromptEnabled': isChatTranscriptPromptEnabled,
      'isOfflineFormEnabled': isOfflineFormEnabled,
      'toolbarTitle': toolbarTitle,
    });
  }

  /// Utility to optionaly add tags to the conversation. This can be set to
  /// a `List` of strings which will then appear to the agent in the chat.
  Future<void> addTags({List<String>? tags}) async {
    await _channel.invokeMethod<void>('addTags', {
      'tags': tags,
    });
  }

  /// Utility to remove tags that were added to the conversation.
  Future<void> removeTags({List<String>? tags}) async {
    await _channel.invokeMethod<void>('removeTags', {
      'tags': tags,
    });
  }

  /// Resets the visitor details to a clean slate allowing a new visitor to chat
  /// Any ongoing chat will be ended, and locally stored information about the visitor will be cleared.
  Future<void> resetIdentity() async {
    await _channel.invokeMethod<void>('resetIdentity');
  }

  /// Sends a new text message and updates the local chat logs.
  Future<void> sendMessage(String message) async {
    await _channel.invokeMethod<void>('sendMessage', {'message': message});
  }
}
