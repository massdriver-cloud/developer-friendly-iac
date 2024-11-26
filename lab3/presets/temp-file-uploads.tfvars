# Context:
# - Ephemeral retention as these files are only needed temporarily (e.g., 7 days).
# - No versioning because overwrites or changes aren't tracked for temporary files.
# - Notifications disabled since no downstream processing is expected.

name_prefix      = "temp-file-uploads"
region           = "us-east-1"
retention_policy = "ephemeral"
versioning_policy = "none"
notify_events    = []
