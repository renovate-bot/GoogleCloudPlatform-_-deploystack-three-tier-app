PROJECT=$1
SQLNAME=$2

SQLSERVICEACCOUNT=$(gcloud sql instances describe $SQLNAME --project $PROJECT --format="value(serviceAccountEmailAddress)" | xargs)
gcloud storage buckets create gs://$PROJECT-temp 
gcloud storage cp schema.sql gs://$PROJECT-temp/schema.sql
gcloud storage buckets add-iam-policy-binding gs://$PROJECT-temp --member=serviceAccount:$SQLSERVICEACCOUNT --role=objectViewer
gcloud sql import sql $SQLNAME gs://$PROJECT-temp/schema.sql -q
gcloud storage rm gs://$PROJECT-temp/schema.sql
gcloud storage buckets delete gs://$PROJECT-temp