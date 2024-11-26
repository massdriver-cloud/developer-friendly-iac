# Context:
# - Indefinite retention as user profile pictures need to be stored long-term.
# - Persistent versioning to keep all changes for historical reference.
# - Notifications enabled for object creation events to trigger downstream processing (e.g., resizing or validation pipelines).

name_prefix      = "user-profile-pictures"
region           = "us-west-2"
retention_policy = "indefinite"
versioning_policy = "persistent"
notify_events    = ["s3:ObjectCreated:*"]