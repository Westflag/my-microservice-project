terraform {
  backend "s3" {
    bucket = "andrew-brelyk-project-tfstate"
    key = "project/terraform.tfstate"
    region = "us-west-2"
    dynamodb_table = "terraform-locks"
    encrypt = true
  }
}
