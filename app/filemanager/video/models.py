from django.db import models
from django.template.defaultfilters import slugify

# Create your models here.
class VideoModel(models.Model):
    """
    Django Model for get Video as input
    and with ASR Models and Whisper Models Return back Audios and transcripts files.
    All these in background
    """
    LANG = {
        'FA':'fa',
        'EN':'en'
    }

    class Status(models.TextChoices):
        UPLOAD ="upload"
        AUDIO = "audio"
        TRANSCRIPT = "transcript"

    class Meta:
        verbose_name = 'Upload Video'
        verbose_name_plural = 'Videos'

    title = models.CharField(max_length=255, null=True, blank=True)
    slug = models.SlugField(max_length=255, null=True, blank=True, unique=True)
    lang = models.CharField(choices=LANG, null=True, blank=True)
    status = models.CharField(choices=Status, default=Status.UPLOAD)
    video = models.FileField(upload_to="upload/videos", null=True, blank=True)
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

    def save(self, *args, **kwargs):
        self.slug = slugify(self.title)

        super(VideoModel, self).save(*args, **kwargs)