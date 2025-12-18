terraform {
  backend "s3" {
    bucket         = "unleash-home-exercise-tm-tf-state-clever-turtle"
    key            = "unleash-home-exercise-tm-apps-deps-tf.tfstate"
    region         = "us-east-1"
    encrypt        = true
  }
}