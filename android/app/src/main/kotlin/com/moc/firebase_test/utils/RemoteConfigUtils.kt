package com.moc.firebase_test.utils

import com.google.firebase.ktx.BuildConfig
import com.google.firebase.ktx.Firebase
import com.google.firebase.remoteconfig.FirebaseRemoteConfig
import com.google.firebase.remoteconfig.ktx.remoteConfig
import com.google.firebase.remoteconfig.ktx.remoteConfigSettings

class RemoteConfigUtils {

    companion object {
        private val TAG = "RemoteConfigUtils"

        private val BUTTON_TEXT = "button_text"
        private val BUTTON_COLOR = "button_color"


        private val SAMPLE_TEXT = "offerwall"

        private val DEFAULTS: HashMap<String, Any> =
                hashMapOf(
                        BUTTON_TEXT to "Local-Default",
                        BUTTON_COLOR to "#0091FF"
                )
        private lateinit var remoteConfig: FirebaseRemoteConfig
        fun init() {
            remoteConfig = getFirebaseRemoteConfig()
        }

        private fun getFirebaseRemoteConfig(): FirebaseRemoteConfig {

            val remoteConfig = Firebase.remoteConfig

            val configSettings = remoteConfigSettings {
                if (BuildConfig.DEBUG) {
                    minimumFetchIntervalInSeconds = 0 // Kept 0 for quick debug
                } else {
                    minimumFetchIntervalInSeconds = 60 * 60 // Change this based on your requirement
                }
            }

            remoteConfig.setConfigSettingsAsync(configSettings)
            remoteConfig.setDefaultsAsync(DEFAULTS)

            remoteConfig.fetchAndActivate().addOnCompleteListener {
                //Logger.d(TAG, "addOnCompleteListener")
            }

            return remoteConfig
        }

        fun getSampleText(): String = remoteConfig.getString(SAMPLE_TEXT)

        fun getNextButtonText(): String = remoteConfig.getString(BUTTON_TEXT)

        fun getNextButtonColor(): String = remoteConfig.getString(BUTTON_COLOR)
    }


}