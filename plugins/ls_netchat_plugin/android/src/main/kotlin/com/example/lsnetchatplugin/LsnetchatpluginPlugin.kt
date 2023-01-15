package com.example.lsnetchatplugin

import android.content.Context
import androidx.annotation.NonNull
import com.netease.nimlib.sdk.*
import com.netease.nimlib.sdk.chatroom.model.ChatRoomMessage
import com.netease.nimlib.sdk.chatroom.model.ChatRoomNotificationAttachment
import com.netease.nimlib.sdk.msg.MsgService
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar
import com.example.lsnetchatplugin.CustomAttachParser
import android.util.Log
import com.google.gson.Gson
import android.R.id.message
import android.R.id.message
import android.R.attr.value

import android.R.attr.key

import android.R.id.message









/** LsnetchatpluginPlugin */
public class LsnetchatpluginPlugin : FlutterPlugin, MethodCallHandler {

    ///聊天室消息监听
    private val messageListener = Observer<List<ChatRoomMessage>> {
        streamEvents?.success(mapOf("type" to ChatRoomResult.receiveMessage, "data" to buildMessage(it).toList()))
    }

    private fun buildMessage(it: List<ChatRoomMessage>): List<Map<String, Any>> {
        return it.map { message ->
            mapOf("content" to if (message.msgType.value == 0) message.content else {
                buildContent(message)
            }
                    , "nicName" to getNic(message)
                    , "msgType" to message.msgType.value
                    , "sessionId" to message.sessionId
                    , "messageType" to getMessageType(message))
        }
    }
    ///获取消息发送人
    private fun getMessageType(message: ChatRoomMessage) : Any {
        var name = "";
        if (message.remoteExtension != null) {
            if (message.remoteExtension["messageType"] != null) {
                var mt = message.remoteExtension["messageType"];
                name = mt.toString();
            }
        }
        return name;
    }
    ///获取消息发送人
    private fun getNic(message: ChatRoomMessage) : Any {

        val gson = Gson()
        //シリアル化
        val jsonString = gson.toJson(message)
        if (jsonString != null) {
            Log.d("message getNic=========",jsonString)
        }

        /*
        //Log.d("getNic=========",message.fromAccount)
        if (message.remoteExtension != null) {
            if (message.remoteExtension["user"] != null) {
                Log.d("getNic=========",message.remoteExtension["user"].toString())
                var user = message.remoteExtension["user"];
                val map = user as Map<String, Any>
                val mapItem = map.entries.iterator()
                while (mapItem.hasNext()) {
                    val (key, value) = mapItem.next()
                    when (key) {
                        "nickName" -> {
                            Log.d("getNicValue=========",value.toString())

                        }
                    }
                }
            }
        }
        */
        var name = "";
        if (message.remoteExtension != null) {
            if (message.remoteExtension["user"] != null) {
                var user = message.remoteExtension["user"];
                val map = user as Map<String, Any>
                var value = map["nickName"];
                name = value.toString();
            }
        }
        return name;
        /*
       return if (message.msgType.value == 0) message.chatRoomMessageExtension.senderNick else if (message.attachment is ChatRoomNotificationAttachment) {
            (message.attachment as ChatRoomNotificationAttachment).operatorNick
        } else message.chatRoomMessageExtension.senderNick

         */
    }

    ///创建内容
    private fun buildContent(message: ChatRoomMessage): Any {
        return if (message.attachment is ChatRoomNotificationAttachment) {
            if ((message.attachment as ChatRoomNotificationAttachment).type.value == 301) {
                "进入直播间"
            } else if ((message.attachment as ChatRoomNotificationAttachment).type.value == 302) {
                "离开直播间"
            } else "未知"
        } else if (message.attachment is ExitMessage) {
            (message.attachment as ExitMessage).message
        } else if (message.msgType.value == 100) {
            var gift = "";
            if (message.remoteExtension != null) {
                if (message.remoteExtension["giftInfo"] != null) {
                    var giftinfo = message.remoteExtension["giftInfo"];
                    val map = giftinfo as Map<String, Any>
                    var value = map["giftNum"].toString() + "个" + map["giftName"].toString();
                    gift = value.toString();
                }
            }
            gift
        } else "未知"
    }

    ///在线状态
    private val statusListener = Observer<StatusCode> {
        streamEvents?.success(mapOf("type" to ChatRoomResult.login, "data" to it.value))
    }


    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        val channel = MethodChannel(flutterPluginBinding.getFlutterEngine().getDartExecutor(), "lsnetchatplugin")
        channel.setMethodCallHandler(this)
        mContext = flutterPluginBinding.applicationContext
        eventChannel = EventChannel(flutterPluginBinding.binaryMessenger, "lsnetchatplugin_e")
        eventChannel?.setStreamHandler(object : EventChannel.StreamHandler {
            override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                streamEvents = events
            }

            override fun onCancel(arguments: Any?) {

            } 
        })
    }

    // This static function is optional and equivalent to onAttachedToEngine. It supports the old
    // pre-Flutter-1.12 Android projects. You are encouraged to continue supporting
    // plugin registration via this function while apps migrate to use the new Android APIs
    // post-flutter-1.12 via https://flutter.dev/go/android-project-migration.
    //
    // It is encouraged to share logic between onAttachedToEngine and registerWith to keep
    // them functionally equivalent. Only one of onAttachedToEngine or registerWith will be called
    // depending on the user's project. onAttachedToEngine or registerWith must both be defined
    // in the same class.
    companion object {
        var eventChannel: EventChannel? = null
        var mContext: Context? = null
        var streamEvents: EventChannel.EventSink? = null
        @JvmStatic
        fun registerWith(registrar: Registrar) {
            val channel = MethodChannel(registrar.messenger(), "lsnetchatplugin")
            var a = registrar.activity();
            mContext = a!!.applicationContext
            eventChannel = EventChannel(registrar.messenger(), "lsnetchatplugin_e")
            channel.setMethodCallHandler(LsnetchatpluginPlugin())
            eventChannel?.setStreamHandler(object : EventChannel.StreamHandler {
                override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                    streamEvents = events
                }

                override fun onCancel(arguments: Any?) {

                }
            })
        }
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        when (call.method) {
            "initChatUtil" -> LsChatUtil.initChat(mContext,call.argument<String>("appKey")!!)
            "login" -> {
                LsChatUtil.login(call.argument<String>("account")!!, call.argument<String>("token")!!, result)
                LsChatUtil.addAuthStatusListener(statusListener, true)
                LsChatUtil.addOrRemoveMessageListener(messageListener, true)
                NIMClient.getService(MsgService::class.java).registerCustomAttachmentParser(CustomAttachParser())
            }
            "logout" -> LsChatUtil.logOut(result)
            "enterChatRoom" -> {
                LsChatUtil.enterWithLog(call.argument<String>("roomId")!!, call.argument<String>("nicName")!!, result)
            }
            "enterChatRoomWithOutLog" -> {
                LsChatUtil.enterWithOutLog(call.argument<String>("roomId")!!, call.argument<String>("url")!!, result)
            }
            "exitChatRoom" -> LsChatUtil.exitChatRoom(call.argument<String>("roomId")!!, result)
            "sendTextMessage" -> LsChatUtil.sendTextMessage(call.argument<String>("message")!!, call.argument<String>("nicName")!!, call.argument<String>("roomId")!!, result)
            "messageListener" -> {
                LsChatUtil.addOrRemoveMessageListener(messageListener, true)
            }
            "removeMessageListener" -> {
                LsChatUtil.addOrRemoveMessageListener(messageListener, false)
            }
            "roomInfo" -> {
                LsChatUtil.getRoomInfo(call.argument<String>("roomId")!!, result)
            }
            "removeListener" -> {
                LsChatUtil.addAuthStatusListener(statusListener, false)
            }
            "sendPlayerExitMessage" -> {
                LsChatUtil.sendPlayerExitMessage(call.argument<String>("roomId")!!, result)
//                LsChatUtil.sendMessage2F()
            }

        }
    }


    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    }


}
