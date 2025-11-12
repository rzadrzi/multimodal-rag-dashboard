from django.contrib import admin
from django.utils.html import format_html
from unfold.admin import ModelAdmin
from .models import VideoModel

@admin.register(VideoModel)
class VideoAdmin(ModelAdmin):
    # change_form_template = "admin/upload_video.html"
    list_display = ("title", "created_at", "updated_at")
    list_filter = ("created_at", "updated_at")
    search_fields = ("title", "created_at", "updated_at")
    list_per_page = 25

    def get_fields(self, request, obj = None):
        if obj is None:
            return ("title", "video")
        else:
            return (
                "title",
                "video",
                "audio",
                "transcript_text",
                "transcript_jsonl"
            )

    def video_icon(self, obj):
        return format_html("ERE" if obj.video else "ttt")
