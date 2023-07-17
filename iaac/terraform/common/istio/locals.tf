locals {
  name = "istio"

  default_helm_config = {
    name      = local.name
    namespace = "default" # change to namespace resources are being created it
    values    = <<VALUES
        # Paste the content of your values.yaml file here
  VALUES
    timeout   = "600"
  }

  helm_config = merge(
    local.default_helm_config,
    var.helm_config
  )

}
