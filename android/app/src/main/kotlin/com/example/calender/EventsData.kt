package com.example.calender

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable
import kotlinx.serialization.json.Json

@Serializable
data class WidgetData(
    val type: String,
    val items: List<WidgetItem>
) {
    companion object {
        fun fromJson(json: String): WidgetData? {
            return try {
                val jsonConfig = Json {
                    ignoreUnknownKeys = true // عشان لو فلاتر بعتت داتا زيادة ميعملش Crash
                    coerceInputValues = true
                }
                jsonConfig.decodeFromString<WidgetData>(json)
            } catch (e: Exception) {
                android.util.Log.e("WIDGET_DEBUG", "Error parsing JSON: ${e.message}")
                null
            }
        }
    }
}

@Serializable
data class WidgetItem(
    val id: String = "",
    val categoryId: String = "",
    val sectionId: String = "",

    @SerialName("title_Ar") val titleAr: String = "",
    @SerialName("title_En") val titleEn: String = "",

    @SerialName("description_Ar") val descriptionAr: String = "",
    @SerialName("description_En") val descriptionEn: String = "",

    @SerialName("location_Ar") val locationAr: String = "",
    @SerialName("location_En") val locationEn: String = "",

    val image: String = "",
    val date: String = "",
    val createdAt: String = "",
    val updatedAt: String = ""
)