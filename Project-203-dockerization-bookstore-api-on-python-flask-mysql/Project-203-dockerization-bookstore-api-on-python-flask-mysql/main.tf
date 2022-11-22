terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.40.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

data "aws_cloudformation_export" "output" {
  
  name = "Bookstore"
  depends_on = [
    aws_cloudformation_stack.docker-compose
  ]

}

data "template_file" "yamlfile" {
  template = file("${abspath(path.module)}/bookstore.yaml")
}

resource "aws_cloudformation_stack" "docker-compose" {
    template_body = data.template_file.yamlfile.rendered
    name = "bookstore"
    tags = {
      "Name" = "docker-bookstore-project"
    }
    on_failure = "ROLLBACK" 
}

output "bookstore_output" {
  value = data.aws_cloudformation_export.output.value
  
}
