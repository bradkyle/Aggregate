# Note the plurality of "objects" here.
load("@io_bazel_rules_k8s//k8s:objects.bzl", "k8s_objects")

load("@k8s_deploy//:defaults.bzl", "k8s_deploy")

NAMESPACE = "nodered"

genrule(
  name="",
  message="",
  cmd="",
)

k8s_object(
  name = NAMESPACE,
  kind = "ns",
  template = ":namespace.yaml"
)

k8s_object(
  name = "nodred-svc",
  kind = "svc",
  namespace = NAMESPACE,
  template = ":nodeport-service.yml",
)

k8s_object(
  name = "nodered-ing",
  kind = "ing",
  namespace = NAMESPACE,
  template = ":ingress-service.yml",
)

k8s_object(
  name = "nodered-pv",
  kind = "pv",
  namespace = NAMESPACE,
  template = ":persistent-volume.yml",
)

k8s_object(
  name = "nodered-pvc",
  kind = "pvc",
  namespace = NAMESPACE,
  template = ":persistent-volume-claim.yml",
)

k8s_object(
  name = "nodered-deploy",
  kind = "deploy",
  namespace = NAMESPACE,
  template = ":deployment.yml",
  images = {
    "gcr.io/rules_k8s/server:dev": "//server:image"
  },
)