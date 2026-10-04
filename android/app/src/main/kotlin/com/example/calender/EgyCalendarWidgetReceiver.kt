package com.example.calender

import android.content.Context
import android.content.Intent
import androidx.glance.appwidget.GlanceAppWidgetManager
import androidx.glance.appwidget.GlanceAppWidgetReceiver
import io.flutter.Log
import kotlinx.coroutines.MainScope
import kotlinx.coroutines.launch

class EgyCalendarWidgetReceiver : GlanceAppWidgetReceiver() {
    override val glanceAppWidget = EgyCalendarWidget()

    override fun onReceive(context: Context, intent: Intent) {
        super.onReceive(context, intent)

        MainScope().launch {
            val manager = GlanceAppWidgetManager(context)
            val ids = manager.getGlanceIds(EgyCalendarWidget::class.java)

            ids.forEach { glanceId ->
                glanceAppWidget.update(context, glanceId)

            }
            Log.d("WIDGET_RECEIVER", "Updated ${ids.size} widgets")
        }
    }
}