Rails.application.config.paperclip_defaults = {
  storage:              :s3,
  s3_host_name:         "s3-us-west-1.amazonaws.com",
  s3_protocol:          "https",
  url:                  ":s3_domain_url",
  path:                 "/:class/:attachment/:id_partition/:style/:filename",
  s3_credentials: {
    bucket:             ENV.fetch("S3_BUCKET_NAME"),
    access_key_id:      ENV.fetch("AWS_ACCESS_KEY_ID"),
    secret_access_key:  ENV.fetch("AWS_SECRET_ACCESS_KEY"),
    s3_region:          ENV.fetch("AWS_REGION"),
  }
}
