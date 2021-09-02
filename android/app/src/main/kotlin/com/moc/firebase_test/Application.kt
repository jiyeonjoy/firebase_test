package com.moc.firebase_test

//import io.flutter.app.FlutterApplication
//import io.flutter.plugin.common.PluginRegistry
//import io.flutter.plugin.common.PluginRegistry.PluginRegistrantCallback
//import io.flutter.plugins.firebasemessaging.FirebaseMessagingPlugin
//import io.flutter.view.FlutterMain
//import io.flutter.plugins.firebasemessaging.FlutterFirebaseMessagingService
//
//class Application : FlutterApplication(), PluginRegistrantCallback {
//
//    override fun onCreate() {
//        super.onCreate()
//        FlutterFirebaseMessagingService.setPluginRegistrant(this);
//        FlutterMain.startInitialization(this)
//    }
//
//    override fun registerWith(registry: PluginRegistry?) {
//        if (!registry!!.hasPlugin("io.flutter.plugins.firebasemessaging")) {
//            FirebaseMessagingPlugin.registerWith(registry!!.registrarFor("io.flutter.plugins.firebasemessaging.FirebaseMessagingPlugin"));
//        }
//    }
//}

//import io.flutter.app.FlutterApplication
//import io.flutter.plugin.common.PluginRegistry
//import io.flutter.plugin.common.PluginRegistry.PluginRegistrantCallback
//import io.flutter.plugins.firebasemessaging.FirebaseMessagingPlugin
//import io.flutter.plugins.firebasemessaging.FlutterFirebaseMessagingService
//
//class Application : FlutterApplication(), PluginRegistrantCallback {
//    override fun onCreate() {
//        super.onCreate()
//        FlutterFirebaseMessagingService.setPluginRegistrant(this)
//    }
//
//    override fun registerWith(registry: PluginRegistry?) {
//        FirebaseMessagingPlugin.registerWith(registry?.registrarFor("io.flutter.plugins.firebasemessaging.FirebaseMessagingPlugin"))
//    }
//}

//import io.flutter.app.FlutterApplication
//import io.flutter.plugin.common.PluginRegistry
//import io.flutter.plugins.firebasemessaging.FlutterFirebaseMessagingService
//
//class Application : FlutterApplication(), PluginRegistry.PluginRegistrantCallback {
//    override fun onCreate() {
//        super.onCreate()
//        FlutterFirebaseMessagingService.setPluginRegistrant(this)
//    }
//
//    override fun registerWith(registry: PluginRegistry?) {
//        FirebaseCloudMessagingPluginRegistrant.registerWith(registry!!)
//    }
//}



//import io.flutter.app.FlutterApplication
//import io.flutter.plugin.common.PluginRegistry
//import io.flutter.plugin.common.PluginRegistry.PluginRegistrantCallback
//import io.flutter.plugins.firebasemessaging.FirebaseMessagingPlugin
//import io.flutter.view.FlutterMain
//import io.flutter.plugins.firebasemessaging.FlutterFirebaseMessagingService
//
//class Application : FlutterApplication(), PluginRegistrantCallback {
//
//    override fun onCreate() {
//        super.onCreate()
//        FlutterFirebaseMessagingService.setPluginRegistrant(this);
//        FlutterMain.startInitialization(this)
//    }
//
//    override fun registerWith(registry: PluginRegistry?) {
//        if (!registry!!.hasPlugin("io.flutter.plugins.firebasemessaging")) {
//            FirebaseMessagingPlugin.registerWith(registry!!.registrarFor("io.flutter.plugins.firebasemessaging.FirebaseMessagingPlugin"));
//        }
//    }
//}

//import android.util.Log
//import io.flutter.app.FlutterApplication
//import io.flutter.plugin.common.PluginRegistry
//import io.flutter.plugins.firebasemessaging.FlutterFirebaseMessagingService
//
//class Application : FlutterApplication(), PluginRegistry.PluginRegistrantCallback {
//    override fun onCreate() {
//        super.onCreate()
//        Log.d("Application.kt", "-------------------------------onCreate")
//        FlutterFirebaseMessagingService.setPluginRegistrant(this)
//    }
//
//    override fun registerWith(registry: PluginRegistry?) {
//        Log.d("Application.kt", "-------------------------------registerWith")
//        FirebaseCloudMessagingPluginRegistrant.registerWith(registry!!)
//    }
//}


import android.util.Log
import io.flutter.app.FlutterApplication
import io.flutter.plugin.common.PluginRegistry
import io.flutter.plugin.common.PluginRegistry.PluginRegistrantCallback
import io.flutter.plugins.firebasemessaging.FirebaseMessagingPlugin
import io.flutter.view.FlutterMain
import io.flutter.plugins.firebasemessaging.FlutterFirebaseMessagingService

class Application : FlutterApplication(), PluginRegistrantCallback {

    override fun onCreate() {
        super.onCreate()
        Log.d("Application.kt", "-------------------------------onCreate")
        FlutterFirebaseMessagingService.setPluginRegistrant(this);
        FlutterMain.startInitialization(this)
    }

    override fun registerWith(registry: PluginRegistry?) {
        Log.d("Application.kt", "-------------------------------registerWith")
        if (!registry!!.hasPlugin("io.flutter.plugins.firebasemessaging")) {
            FirebaseMessagingPlugin.registerWith(registry!!
                    .registrarFor("io.flutter.plugins.firebasemessaging.FirebaseMessagingPlugin"));
        }
    }
}