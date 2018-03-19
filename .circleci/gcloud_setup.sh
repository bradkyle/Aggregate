apk --update add openjdk7-jre
gcloud components install app-engine-java kubectl
gcloud --quiet components update
gcloud auth activate-service-account --key-file=${HOME}/gcloud-service-key.json
gcloud --quiet config set project ${GOOGLE_PROJECT_ID}
gcloud --quiet config set compute/zone ${GOOGLE_COMPUTE_ZONE}
gcloud --quiet container clusters get-credentials ${GOOGLE_CLUSTER_NAME}  
