package com.moc.firebase_test

//import android.util.Log
//import androidx.annotation.NonNull;
//import io.flutter.embedding.android.FlutterActivity
//import io.flutter.embedding.engine.FlutterEngine
//import io.flutter.plugins.GeneratedPluginRegistrant
//
//class MainActivity: FlutterActivity() {
//    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
//        Log.d("MainActivity.kt", "-------------------------------configureFlutterEngine")
//        GeneratedPluginRegistrant.registerWith(flutterEngine);
//    }
//}

import android.os.Bundle
import android.util.Log
import androidx.annotation.NonNull
import com.google.firebase.installations.FirebaseInstallations
import com.moc.firebase_test.utils.RemoteConfigUtils
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.PluginRegistry
import io.flutter.plugins.GeneratedPluginRegistrant
import io.flutter.plugins.firebasemessaging.FirebaseMessagingPlugin


class MainActivity : FlutterActivity(), PluginRegistry.PluginRegistrantCallback {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
//        FlutterFirebaseMessagingService.setPluginRegistrant(this);
//        FlutterMain.startInitialization(this)

        FirebaseInstallations.getInstance().getToken(/* forceRefresh */ true)
                .addOnCompleteListener { task ->
                    if (task.isSuccessful) {
                        Log.d("Installations", "Installation auth token: " + task.result?.token)
                    } else {
                        Log.e("Installations", "Unable to get Installation auth token")
                    }
                }

        val rc = RemoteConfigUtils.init()
        val str = RemoteConfigUtils.getSampleText()

        Log.d("Installations", "---------- offerwall : $str")

    }

    override fun registerWith(registry: PluginRegistry?) {
        if (!registry!!.hasPlugin("io.flutter.plugins.firebasemessaging")) {
            FirebaseMessagingPlugin.registerWith(registry!!.registrarFor("io.flutter.plugins.firebasemessaging.FirebaseMessagingPlugin"));
        }
    }

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine);
    }
}