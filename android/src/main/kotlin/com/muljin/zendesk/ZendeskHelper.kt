package com.muljin.zendesk

import android.app.Activity
import androidx.annotation.NonNull
import com.zendesk.logger.Logger
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import zendesk.chat.*
import zendesk.classic.messaging.MessagingActivity


/** ZendeskHelper */
class ZendeskHelper : FlutterPlugin, MethodCallHandler, ActivityAware {
  // / The MethodChannel that will the communication between Flutter and native Android
  // /
  // / This local reference serves to register the plugin with the Flutter Engine and unregister it
  // / when the Flutter Engine is detached from the Activity
  private lateinit var channel: MethodChannel
  private lateinit var activity: Activity

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "zendesk")
    channel.setMethodCallHandler(this)
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

  override fun onDetachedFromActivity() {
  }

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
  }

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
      activity = binding.activity
  }

  override fun onDetachedFromActivityForConfigChanges() {
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {

try {


    when (call.method) {
      "getPlatformVersion" -> {
          result.success("Android ${android.os.Build.VERSION.RELEASE}")
      }
      "initialize" -> {
        initialize(call)
        result.success(true)
      }
      "setVisitorInfo" -> {
        setVisitorInfo(call)
        result.success(true)
      }
      "startChat" -> {
        startChat(call)
        result.success(true)
      }
      "addTags" -> {
        addTags(call)
        result.success(true)
      }
      "removeTags" -> {
        removeTags(call)
        result.success(true)
      }
      else -> {
        result.notImplemented()
      }

    }
}catch (e:Exception){
  result.error("unKnowen",e.message,e.toString());
}
  }

  fun initialize(call: MethodCall) {
    Logger.setLoggable(BuildConfig.DEBUG)
    val accountKey = call.argument<String>("accountKey") ?: ""
    val applicationId = call.argument<String>("appId") ?: ""

    Chat.INSTANCE.init(activity, accountKey, applicationId)
  }

  fun setVisitorInfo(call: MethodCall) {
    val name = call.argument<String>("name") ?: ""
    val email = call.argument<String>("email") ?: ""
    val phoneNumber = call.argument<String>("phoneNumber") ?: ""
    val department = call.argument<String>("department") ?: ""

    val profileProvider = Chat.INSTANCE.providers()?.profileProvider()
    val chatProvider = Chat.INSTANCE.providers()?.chatProvider()

    val visitorInfo = VisitorInfo.builder()
                                    .withName(name)
                                    .withEmail(email)
                                    .withPhoneNumber(phoneNumber) // numeric string
                                    .build()
    profileProvider?.setVisitorInfo(visitorInfo, null)
    chatProvider?.setDepartment(department, null)
  }

  fun addTags(call: MethodCall) {
    val tags = call.argument<List<String>>("tags") ?: listOf<String>()
    val profileProvider = Chat.INSTANCE.providers()?.profileProvider()
    profileProvider?.addVisitorTags(tags, null)
  }

  fun removeTags(call: MethodCall) {
    val tags = call.argument<List<String>>("tags") ?: listOf<String>()
    val profileProvider = Chat.INSTANCE.providers()?.profileProvider()
    profileProvider?.removeVisitorTags(tags, null)
  }

  fun startChat(call: MethodCall) {
    val toolbarTitle = call.argument<String>("toolbarTitle") ?: "Contact Us"
    val botName = call.argument<String>("botName") ?: "Answer Bot"
    val isPreChatFormEnabled = call.argument<Boolean>("isPreChatFormEnabled") ?: true
    val isPreChatEmailField = call.argument<Boolean>("isPreChatEmailField") ?: true
    val isPreChatNameField = call.argument<Boolean>("isPreChatNameField") ?: true
    val isPreChatPhoneField = call.argument<Boolean>("isPreChatPhoneField") ?: true
    val isAgentAvailabilityEnabled = call.argument<Boolean>("isAgentAvailabilityEnabled") ?: true
    val isChatTranscriptPromptEnabled = call.argument<Boolean>("isChatTranscriptPromptEnabled") ?: true
    val isOfflineFormEnabled = call.argument<Boolean>("isOfflineFormEnabled") ?: true
    val disableEndChatMenuAction = call.argument<Boolean>("disableEndChatMenuAction")?:false

    val chatMenuAction = if (disableEndChatMenuAction) ChatMenuAction.CHAT_TRANSCRIPT else ChatMenuAction.END_CHAT
    val withEmailField = if (isPreChatEmailField) PreChatFormFieldStatus.OPTIONAL else PreChatFormFieldStatus.HIDDEN
    val withNameField = if (isPreChatNameField) PreChatFormFieldStatus.OPTIONAL else PreChatFormFieldStatus.HIDDEN
    val withPhoneField = if (isPreChatPhoneField) PreChatFormFieldStatus.OPTIONAL else PreChatFormFieldStatus.HIDDEN

    val chatConfigurationBuilder = ChatConfiguration.builder()
    chatConfigurationBuilder
        .withAgentAvailabilityEnabled(isAgentAvailabilityEnabled)
        .withTranscriptEnabled(isChatTranscriptPromptEnabled)
        .withOfflineFormEnabled(isOfflineFormEnabled)
        .withEmailFieldStatus(withEmailField)
        .withNameFieldStatus(withNameField)
        .withPhoneFieldStatus(withPhoneField)
        .withPreChatFormEnabled(isPreChatFormEnabled)
        .withChatMenuActions(chatMenuAction)

    val chatConfiguration = chatConfigurationBuilder.build()

try {
  MessagingActivity.builder()
          .withToolbarTitle(toolbarTitle)
          .withBotLabelString(botName)
          .withEngines(ChatEngine.engine())
          .show(activity, chatConfiguration)
}catch ( e:Exception){
 throw e;
}

  }
}
