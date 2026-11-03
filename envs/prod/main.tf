terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 3.4"
    }
  }
}

provider "kubernetes" {
  config_path    = "~/.kube/config"
  config_context = "kind-terraform-lab"
}

module "hello_app" {
  source = "../../modules/hello-app"

  namespace = "prod"
  replicas  = 3
  port      = 8090
  image_tag = "v2"
}

output "url" {
  value = module.hello_app.url
}
