velero install \
  --backup-location-config s3Url=https://storage.yandexcloud.net,region=ru-central1 \
  --bucket simba-kjh-01-velero-backup \
  --plugins velero/velero-plugin-for-aws:v1.4.0 \
  --provider aws \
  --secret-file ./backupcredentials.txt \
  --use-restic \
  --use-volume-snapshots false
