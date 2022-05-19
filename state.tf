terraform {
  backend "s3"{
    region     = "ap-southeast-1"
    bucket     = "terraformmys3"
    key        = "terraform.tfstate"
    encrypt    = "false"
  }
}