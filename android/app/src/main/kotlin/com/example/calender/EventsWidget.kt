package com.example.calender

import android.content.Context
import androidx.compose.runtime.Composable
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.glance.*
import android.content.Intent
import androidx.compose.runtime.key
import androidx.compose.ui.unit.Dp
import androidx.glance.action.clickable
import androidx.glance.appwidget.GlanceAppWidget
import androidx.glance.appwidget.action.actionStartActivity
import androidx.glance.appwidget.cornerRadius
import androidx.glance.appwidget.provideContent
import androidx.glance.appwidget.lazy.LazyColumn
import androidx.glance.appwidget.lazy.items
import androidx.glance.layout.*
import androidx.glance.text.*
import androidx.core.net.toUri
import androidx.glance.color.ColorProvider
import io.flutter.Log

class EgyCalendarWidget : GlanceAppWidget() {

    override suspend fun provideGlance(context: Context, id: GlanceId) {
        val settings = getSettingsFresh(context)

        val prefs = context.getSharedPreferences("HomeWidgetPreferences", Context.MODE_PRIVATE)
        val jsonString = prefs.getString("events", null)

        val data = if (!jsonString.isNullOrEmpty()) {
            WidgetData.fromJson(jsonString)
        } else null

        provideContent {

            key(settings.hashCode()) {
                WidgetLayout(data, settings)
            }
        }
    }

    private fun getSettingsFresh(context: Context): WidgetSettings {
        val prefs = context.getSharedPreferences("HomeWidgetPreferences", Context.MODE_PRIVATE)
        val json = prefs.getString("widget_settings", null)

        Log.d("WIDGET_SYNC", "Detected Changes: $json")

        return try {
            if (!json.isNullOrEmpty()) {
                WidgetParser.json.decodeFromString<WidgetSettings>(json)
            } else WidgetSettings()
        } catch (e: Exception) {
            WidgetSettings()
        }
    }
}
/* -------------------------------------------------------------------------- */
@Composable
private fun WidgetLayout(
    data: WidgetData?,
    settings: WidgetSettings
) {
    val isDark = settings.theme == "dark"
    val isRtl = settings.language == "arabic"

    val bgColor = if (isDark) Color(0xFF121212) else Color(0xFFFFFFFF)
    val primaryText = if (isDark) Color.White else Color.Black
    val secondaryText = if (isDark) Color(0xFFAAAAAA) else Color(0xFF666666)
    val accentColor = Color(0xFF4CAF50)

    Column(
        modifier = GlanceModifier
            .fillMaxSize()
            .background(bgColor)
            .padding(12.dp)
            .clickable(actionStartActivity(
                Intent(
                    Intent.ACTION_VIEW,
                )
            )),
        horizontalAlignment = if (isRtl) Alignment.End else Alignment.Start
    ) {
        // Header
        Text(
            text = if (isRtl) "📅 التقويم المصري" else "📅 Egyptian Calendar",
            style = TextStyle(
                fontSize = (16 * settings.fontSizeMultiplier).sp,
                fontWeight = FontWeight.Bold,
                color = ColorProvider(day = primaryText, night = primaryText)
            )
        )
        Spacer(modifier = GlanceModifier.height(8.dp))

        if (data == null || data.items.isEmpty()) {
            Box(
                modifier = GlanceModifier
                    .fillMaxSize()
                    .clickable(actionStartActivity(
                        Intent(
                            Intent.ACTION_VIEW,
                        )
                    )),
                contentAlignment = Alignment.Center
            ) {
                Text(
                    text = if (isRtl) "لا توجد أحداث اليوم" else "No events today",
                    style = TextStyle(color = ColorProvider(day = secondaryText, night = secondaryText))
                )
            }
        } else {
            when (settings.layoutType) {
                "grid" -> {
                    LazyColumn {
                        items(data.items.chunked(2)) { rowItems ->
                            Row {
                                rowItems.forEach { item ->
                                    EventItem(
                                        item,
                                        primaryText,
                                        secondaryText,
                                        accentColor,
                                        isRtl,
                                        settings.fontSizeMultiplier,
                                        height = settings.cardHeight.dp
                                    )
                                    Spacer(modifier = GlanceModifier.width(8.dp))
                                }
                            }
                        }
                    }
                }
                "twoColumns" -> {
                    LazyColumn {
                        items(data.items.chunked(2)) { rowItems ->
                            Row {
                                rowItems.forEach { item ->
                                    EventItem(
                                        item,
                                        primaryText,
                                        secondaryText,
                                        accentColor,
                                        isRtl,
                                        settings.fontSizeMultiplier,
                                        height = settings.cardHeight.dp
                                    )
                                    Spacer(modifier = GlanceModifier.width(8.dp))
                                }
                            }
                        }
                    }
                }
                else -> { // default list
                    LazyColumn {
                        items(data.items) { item ->
                            EventItem(
                                item,
                                primaryText,
                                secondaryText,
                                accentColor,
                                isRtl,
                                settings.fontSizeMultiplier,
                                height = settings.cardHeight.dp
                            )
                        }
                    }
                }
            }
        }
    }
}

/* -------------------------------------------------------------------------- */
@Composable
private fun EventItem(
    item: WidgetItem,
    primary: Color,
    secondary: Color,
    accent: Color,
    isRtl: Boolean,
    fontMultiplier: Float,
    height: Dp = 54.dp
) {
    Box(
        modifier = GlanceModifier
            .fillMaxWidth()
            .padding(vertical = 4.dp)
            .clickable(
                actionStartActivity(
                    Intent(
                        Intent.ACTION_VIEW,
                        "dlink://events/event_details/${item.id}".toUri()
                    )
                )
            ),
    ) {
        Row(
            verticalAlignment = Alignment.CenterVertically

        ) {
            // Vertical indicator
            Box(
                modifier = GlanceModifier
                    .width(4.dp)
                    .height(height)
                    .cornerRadius(12.dp)
                    .background(accent)
            ){}
            Column(
                modifier = GlanceModifier
                    .defaultWeight()
                    .fillMaxWidth()
                    .background(accent.copy(alpha = 0.15f))
                    .cornerRadius(12.dp)
                    .padding(12.dp)

            ) {
                Text(
                    text = if (isRtl) item.titleAr else item.titleEn,
                    maxLines = 1,
                    style = TextStyle(
                        fontSize = (14 * fontMultiplier).sp,
                        fontWeight = FontWeight.Bold,
                        color = ColorProvider(day = primary, night = primary)
                    )
                )

                if (item.descriptionEn.isNotEmpty()) {
                    Text(
                        text = if (isRtl) item.descriptionAr else item.descriptionEn,
                        maxLines = 1,
                        style = TextStyle(
                            fontSize = (12 * fontMultiplier).sp,
                            color = ColorProvider(day = secondary, night = secondary)
                        )
                    )
                }

                Text(
                    text = item.date.take(10),
                    style = TextStyle(
                        fontSize = 10.sp,
                        color = ColorProvider(day = accent, night = accent)
                    )
                )
            }
        }
    }
}
