terraform {
  backend "s3" {
    bucket         = "unleash-home-exercise-tm-tf-state-clever-turtle"
    key            = "unleash-home-exercise-tm-apps-deps-tf.tfstate"
    region         = "us-east-1"
    encrypt        = true
  }
  
  required_providers {
    helm = {
      source = "hashicorp/helm"
      version = "3.1.1"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "3.0.1"
    }
  }
}