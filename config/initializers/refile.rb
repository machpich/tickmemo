require "refile/s3"

if Rails.env.production?
  aws = {
    access_key_id: Rails.application.secrets.s3_access_key_id,
    secret_access_key: Rails.application.secrets.s3_secret_access_key,
    region: "ap-northeast-1",
    bucket: "for-tickmemo"
  }

  Refile.cache = Refile::S3.new(prefix: "cache", **aws)
  Refile.store = Refile::S3.new(prefix: "store", **aws)
end