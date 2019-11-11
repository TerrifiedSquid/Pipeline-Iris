 provider "github" {
 organization = "${var.github_organization}"
 token        = "${var.TOKEN}"  
  } 

# Example terraform command
 resource "github_membership" "dogi" {
 username = "dogi"
 role = "member" 
 }

