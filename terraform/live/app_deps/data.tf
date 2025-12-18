data "terraform_remote_state" "eks" {
  backend = "s3"
  config = {
    bucket         = "unleash-home-exercise-tm-tf-state-clever-turtle"
    key            = "unleash-home-exercise-tm-eks-tf.tfstate"
    region         = "us-east-1"
    encrypt        = true
  }
}
