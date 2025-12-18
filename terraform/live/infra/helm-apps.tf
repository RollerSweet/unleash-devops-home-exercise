resource "helm_release" "ingress_nginx" {
  depends_on = [module.eks]
  name       = "ingress-nginx"
  namespace  = "ingress-nginx"

  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  version    = "4.14.0"

  create_namespace = true

  timeout = 600
  wait    = true

  values = [
    yamlencode({
      controller = {
        ingressClass = "nginx"
        ingressClassResource = {
          name    = "nginx"
          enabled = true
          default = true
        }

        service = {
          type                  = "LoadBalancer"
          annotations           = {}
          externalTrafficPolicy = "Local"
        }
      }
    })
  ]
}