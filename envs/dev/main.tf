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

  namespace = "dev"
  replicas  = 2
  port      = 8080
  image_tag = "v2"
}

output "url" {
  value = module.hello_app.url
}
