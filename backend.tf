terraform {
  backend "s3" {
    bucket         = "andrew-brelyk-lesson-7-tfstate"
    key            = "lesson-7/terraform.tfstate"
    region         = "us-west-2"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}
