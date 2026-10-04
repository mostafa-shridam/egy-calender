package com.example.calender

import kotlinx.serialization.Serializable
import kotlinx.serialization.json.Json

@Serializable
data class WidgetSettings(
    val theme: String = "light",
    val language: String = "en",
    val fontSizeMultiplier: Float = 1.0f,
    val layoutType: String = "list", // "list", "grid", "twoColumns"
    val cardHeight: Int = 54, // ارتفاع الكارد
)


object WidgetParser {
    val json = Json {
        ignoreUnknownKeys = true
        coerceInputValues = true
    }
}