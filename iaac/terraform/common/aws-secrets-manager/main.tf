module "helm_addon" {
  source = "github.com/codinglama-tech/terraform-aws-eks-blueprints//modules/kubernetes-addons/helm-addon?ref=fix-aws-auth-dep-nodegroup"
  helm_config   = local.helm_config
  addon_context = var.addon_context
}
