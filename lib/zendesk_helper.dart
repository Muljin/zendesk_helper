// ignore_for_file: avoid_classes_with_only_static_members
import 'dart:async';
import 'dart:ui';

import 'package:flutter/services.dart';

/// Provides embed chat functionality
class Zendesk {
  static const MethodChannel _channel = MethodChannel('zendesk');

  /// Initialize the Zendesk SDK with the provided [accountKey] and [appId]
  ///
  /// Offical Docs
  /// iOS: https://developer.zendesk.com/embeddables/docs/chat-sdk-v-2-for-ios/getting_started#initializing-the-sdk
  /// Android: https://developer.zendesk.com/embeddables/docs/chat-sdk-v-2-for-android/getting_started#initializing-the-sdk
  static Future<void> initialize(String accountKey, String appId) async {
    await _channel.invokeMethod<void>('initialize', {
      'accountKey': accountKey,
      'appId': appId,
    });
  }

  /// Convenience utility to prefill visitor information and optionally set
  /// a support [department]
  static Future<void> setVisitorInfo({
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
  static Future<void> startChat({
    Color? primaryColor,
    bool isPreChatFormEnabled = true,
    bool isAgentAvailabilityEnabled = true,
    bool isChatTranscriptPromptEnabled = true,
    bool isOfflineFormEnabled = true,
  }) async {
    await _channel.invokeMethod<void>('startChat', {
      'primaryColor': primaryColor?.value,
      'isPreChatFormEnabled': isPreChatFormEnabled,
      'isAgentAvailabilityEnabled': isAgentAvailabilityEnabled,
      'isChatTranscriptPromptEnabled': isChatTranscriptPromptEnabled,
      'isOfflineFormEnabled': isOfflineFormEnabled
    });
  }

  /// Utility to optionaly add tags to the conversation. This can be set to
  /// a `List` of strings which will then appear to the agent in the chat.
  static Future<void> addTags({List<String>? tags}) async {
    await _channel.invokeMethod<void>('addTags', {
      'tags': tags,
    });
  }

  /// Utility to remove tags that were added to the conversation.
  static Future<void> removeTags({List<String>? tags}) async {
    await _channel.invokeMethod<void>('removeTags', {
      'tags': tags,
    });
  }
}
