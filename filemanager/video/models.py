from django.db import models

# Create your models here.
class VideoModel(models.Model):
    """
    Django Model for get Video as input
    and with ASR Models and Whisper Models Return back Audios and transcripts files.
    All these in background
    """
    class Meta:
        verbose_name = 'Upload'
        verbose_name_plural = 'Uploads'

    title = models.CharField(max_length=255, null=True, blank=True)
    slug = models.SlugField(max_length=255, null=True, blank=True)
    video = models.FileField(upload_to="upload/videos")
    audio = models.FileField(upload_to="upload/audios", blank=True, null=True)
    transcript_text = models.TextField(blank=True, null=True)
    transcript_jsonl = models.FileField(
        upload_to="upload/transcripts", blank=True, null=True
    )
    transcript_srt = models.FileField(
        upload_to="upload/srt", blank=True, null=True
    )
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)


    def __str__(self):
        return self.title