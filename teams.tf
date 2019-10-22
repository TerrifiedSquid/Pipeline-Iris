 provider "github" {
 organization = "${var.github_organization}"
 token        = "${var.TOKEN}"  
  } 


 resource "github_membership" "GITHUB_USERNAME" {
 username = "GITHUB_USERNAME"
 role = "member" 
 }

